import { FastifyRequest, FastifyReply } from 'fastify';
export declare function metricsMiddleware(req: any, res: any, next: () => void): void;
export declare function renderMetrics(_req: FastifyRequest, res: FastifyReply): Promise<void>;
