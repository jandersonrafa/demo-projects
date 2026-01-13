import http from 'k6/http';
import { check, sleep } from 'k6';

// 👉 IMPORT DO HTML REPORTER
import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";

// Read TARGETS env var: comma-separated host:port
const targetsEnv = __ENV.TARGETS || '';
const targets = targetsEnv.split(',').filter(Boolean);

// { duration: '1m', target: 20 },
// { duration: '1m', target: 80 },
// { duration: '1m', target: 120 }, // 🎯 pico
// { duration: '2m', target: 120 }, // sustentação
// { duration: '1m', target: 0 },
// Build scenarios: one per target (20 RPS cada)
export const options = {
  scenarios: Object.fromEntries(
    targets.map((t) => [
      `load_${t.replace(/[^a-zA-Z0-9]/g, '_')}`,
      {
        executor: 'ramping-arrival-rate',
        startRate: 20,
        timeUnit: '1s',
        stages: [
          { duration: '1m', target: 100 },
          { duration: '1m', target: 200 },
          { duration: '1m', target: 300 },
          { duration: '1m', target: 400 },
          { duration: '1m', target: 500 }, // 🎯 pico
          { duration: '1m', target: 0 },// sustentação
        ],
        preAllocatedVUs: 100,
        maxVUs: 600,
        exec: 'hit',
        env: { TARGET: t },
        tags: { target: t },
      },
    ])
  ),

  thresholds: {
    http_req_duration: ['p(95)<1000'],
    http_req_failed: ['rate<0.01'],
  },
};

export function hit() {
  const target = __ENV.TARGET;
  const base = `http://${target}`;

  // POST /bonus para cadastro (todos os gateways devem ter)
  const payload = JSON.stringify({
    amount: 150.00,
    description: `Load Test ${Date.now()}`,
    clientId: `client_${Math.floor(Math.random() * 100) + 1}`
  });
  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };
  const res = http.post(`${base}/bonusteste`, payload, params);


  check(res, {
    'http_success': (r) => r.status >= 200 && r.status < 400,
  });

  // if (res.status >= 400) {
  //   console.error(
  //     `[ERROR] target=${target} ` +
  //     `status=${res.status} ` +
  //     `body=${res.body?.substring(0, 200)}`
  //   );
  // }
  // sleep(1);
}

// ✅ RELATÓRIO AUTOMÁTICO (HTML + JSON)
export function handleSummary(data) {
  const timestamp = new Date().toISOString().replace(/T/, '_').replace(/\..+/, '').replace(/:/g, '-');
  // Extrai apenas as portas dos alvos (ex: 3005) e junta com '_'
  const ports = targets.map(t => t.split(':').pop()).join('_');
  const reportName = ports ? `summary-${timestamp}-${ports}` : `summary-${timestamp}`;

  return {
    [`/reports/${reportName}.html`]: htmlReport(data),
    [`/reports/${reportName}.json`]: JSON.stringify(data, null, 2),
  };
}

