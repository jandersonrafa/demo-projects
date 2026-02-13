import { FastifyRequest, FastifyReply } from 'fastify';
import client from 'prom-client';

const register = new client.Registry();

client.collectDefaultMetrics({ register });

const httpRequestsTotal = new client.Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method', 'status', 'path'] as const,
  registers: [register],
});

const httpRequestDurationSeconds = new client.Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration in seconds',
  labelNames: ['method', 'status', 'path'] as const,
  buckets: [0.001, 0.005, 0.01, 0.025, 0.05, 0.075, 0.1, 0.25, 0.5, 0.75, 1, 2.5, 5, 7.5, 10],
  registers: [register],
});

export function metricsMiddleware(req: any, res: any, next: () => void) {
  const start = process.hrtime.bigint();
  res.on('finish', () => {
    const diffNs = Number(process.hrtime.bigint() - start);
    const seconds = diffNs / 1e9;
    const labels = {
      method: (req.method || 'GET').toUpperCase(),
      status: String(res.statusCode),
      path: req.raw?.url || req.url || 'unknown',
    } as const;
    httpRequestsTotal.inc(labels);
    httpRequestDurationSeconds.observe(labels, seconds);
  });
  next();
}

export async function renderMetrics(_req: FastifyRequest, res: FastifyReply) {
  res.header('Content-Type', register.contentType);
  res.send(await register.metrics());
}
