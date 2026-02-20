import client from 'prom-client';
import { FastifyInstance, FastifyReply, FastifyRequest } from 'fastify';
import { NestFastifyApplication } from '@nestjs/platform-fastify';

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

type FastifyReq = FastifyRequest & { startTime?: bigint };

export function setupMetrics(app: NestFastifyApplication) {
  const fastify = app.getHttpAdapter().getInstance() as FastifyInstance;

  fastify.addHook('onRequest', async (request: FastifyReq) => {
    request.startTime = process.hrtime.bigint();
  });

  fastify.addHook('onResponse', async (request: FastifyReq, reply: FastifyReply) => {
    if (!request.startTime) return;
    const diffNs = Number(process.hrtime.bigint() - request.startTime);
    const seconds = diffNs / 1e9;
    const labels = {
      method: (request.method || 'GET').toUpperCase(),
      status: String(reply.statusCode),
      path: request.routeOptions?.url || request.url || 'unknown',
    } as const;
    httpRequestsTotal.inc(labels);
    httpRequestDurationSeconds.observe(labels, seconds);
  });

  fastify.get('/metrics', async (_req: FastifyRequest, reply: FastifyReply) => {
    reply.header('Content-Type', register.contentType);
    return register.metrics();
  });
}
