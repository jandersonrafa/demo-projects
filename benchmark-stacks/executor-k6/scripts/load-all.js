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
        executor: 'ramping-vus',

        stages: [
          { duration: '1m', target: 500 }, // sobe até 500 VUs
          { duration: '2m', target: 500 }, // mantém 500 VUs
          { duration: '1m', target: 0 },   // desce para 0 VUs
        ],
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
    http_success: (r) => r.status >= 200 && r.status < 400,
  });

  sleep(1); // 1 segundo entre requisições

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
