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

        timeUnit: '1s',
        startRate: 50,

        stages: [
          { duration: '30s', target: 50 },
          { duration: '30s', target: 100 },
          { duration: '30s', target: 150 },
          { duration: '30s', target: 200 }, // 🔥 warm-up completo (2 min)
          { duration: '2m', target: 200 }, // 🎯 carga real
        ],

        preAllocatedVUs: 300,
        maxVUs: 600,

        exec: 'hit',
        env: { TARGET: t },
        tags: { target: t },
      },
    ])
  ),

  thresholds: {
    'http_req_duration{method:POST}': ['p(95)<200'],
    'http_req_duration{method:GET}': ['p(95)<200'],
    http_req_failed: ['rate<0.01'],
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

  const payload = JSON.stringify({
    amount: 150.00,
    description: `Load Test ${Date.now()}`,
    clientId: `client_${Math.floor(Math.random() * 100) + 1}`,
  });

  const params = {
    headers: { 'Content-Type': 'application/json' },
  };

  const res = http.post(`${base}/bonus`, payload, params);

  check(res, {
    'POST /bonus success': (r) => r.status >= 200 && r.status < 400,
  });

  const resRecents = http.get(`${base}/bonus/recents`);

  check(resRecents, {
    'GET /bonus/recents success': (r) => r.status >= 200 && r.status < 400,
  });

  // sleep(1); // 1 segundo entre requisições

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
