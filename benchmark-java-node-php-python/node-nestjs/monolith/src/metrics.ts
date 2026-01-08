import { Request, Response, NextFunction } from 'express';
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
    buckets: [0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10],
    registers: [register],
});

export function metricsMiddleware(req: Request, res: Response, next: NextFunction) {
    const start = process.hrtime.bigint();
    res.on('finish', () => {
        const diffNs = Number(process.hrtime.bigint() - start);
        const seconds = diffNs / 1e9;
        const labels = {
            method: (req.method || 'GET').toUpperCase(),
            status: String(res.statusCode),
            path: req.route?.path || req.path || 'unknown',
        } as const;
        httpRequestsTotal.inc(labels);
        httpRequestDurationSeconds.observe(labels, seconds);
    });
    next();
}

export async function renderMetrics(_req: Request, res: Response) {
    res.setHeader('Content-Type', register.contentType);
    res.end(await register.metrics());
}
