import http from 'k6/http';
import { sleep, check } from 'k6';

// 👉 IMPORT DO HTML REPORTER
import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";

// Read TARGETS env var: comma-separated host:port
const targetsEnv = __ENV.TARGETS || '';
const targets = targetsEnv.split(',').filter(Boolean);

export const options = {
  scenarios: Object.fromEntries(
    targets.map((t) => [
      `load_${t.replace(/[^a-zA-Z0-9]/g, '_')}`,
      {
        executor: 'ramping-arrival-rate',
        startRate: 20,
        timeUnit: '1s',
        stages: [
          // Warm-up rápido (essencial para JIT/AOT)
          { target: 100, duration: '1m' },   // subindo + 2 min estável
          { target: 100, duration: '1m' },

          // Ramp intermediário curto
          { target: 300, duration: '1m' },

          // Ramp final + plateau em 500
          { target: 500, duration: '2m' },   // sobe para 500
          { target: 500, duration: '5m' },   // ~5 min estável → métrica principal
        ],
        preAllocatedVUs: 100,
        maxVUs: 250,
        exec: 'hit',
        env: { TARGET: t },
        tags: { target: t },
      },
    ])
  ),

  thresholds: {
    'http_req_duration{method:POST}': ['p(95)<200'],
    'http_req_duration{method:GET}': ['p(95)<200'],
    'http_req_failed': ['rate<0.01'],
  },

  ext: {
    prometheus: {
      buckets: [
        0.01, 0.025, 0.05, 0.075, 0.1, 0.15, 0.2, 0.3, 0.4, 0.6, 0.8, 1.2, 2.0, 3.0
      ],
    },
  },
};

export function hit() {
  const target = __ENV.TARGET;
  const base = `http://${target}`;

  const FIXED_TEXT = `
Este texto simula um payload realista para testes de carga em APIs REST,
permitindo avaliar parsing de JSON, uso de memória e serialização de dados
em forma controlada e reprodutível.
`;

  const payload = JSON.stringify({
    amount: 150.00,
    description: `Load Test ${Date.now()} - ${FIXED_TEXT}`,
    clientId: `client_${Math.floor(Math.random() * 100) + 1}`,
  });

  /** POST /bonus */
  const postParams = {
    headers: { 'Content-Type': 'application/json' },
    tags: {
      endpoint: 'POST /bonus',
      service: 'bonus',
      method: 'POST',
    },
  };

  const resPost = http.post(`${base}/bonus`, payload, postParams);

  check(resPost, {
    'POST /bonus success': (r) => r.status >= 200 && r.status < 400,
  });

  /** GET /bonus/recents */
  const getParams = {
    tags: {
      endpoint: 'GET /bonus/recents',
      service: 'bonus',
      method: 'GET',
    },
  };

  const resRecents = http.get(`${base}/bonus/recents`, getParams);

  check(resRecents, {
    'GET /bonus/recents success': (r) => r.status >= 200 && r.status < 400,
  });
}
// ✅ RELATÓRIO AUTOMÁTICO (HTML + JSON)
export function handleSummary(data) {
  const now = new Date();
  const brazilTime = new Date(now.getTime() - 3 * 60 * 60 * 1000);
  const timestamp = brazilTime
    .toISOString()
    .replace(/T/, '_')
    .replace(/\..+/, '')
    .replace(/:/g, '-');

  const ports = targets.map(t => t.split(':').pop()).join('_');
  const reportName = ports
    ? `summary-${timestamp}-BR-${ports}`
    : `summary-${timestamp}-BR`;

  return {
    [`/reports/${reportName}.html`]: htmlReport(data),
    [`/reports/${reportName}.json`]: JSON.stringify(data, null, 2),
  };
}
