"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.metricsMiddleware = metricsMiddleware;
exports.renderMetrics = renderMetrics;
const prom_client_1 = __importDefault(require("prom-client"));
const register = new prom_client_1.default.Registry();
prom_client_1.default.collectDefaultMetrics({ register });
const httpRequestsTotal = new prom_client_1.default.Counter({
    name: 'http_requests_total',
    help: 'Total HTTP requests',
    labelNames: ['method', 'status', 'path'],
    registers: [register],
});
const httpRequestDurationSeconds = new prom_client_1.default.Histogram({
    name: 'http_request_duration_seconds',
    help: 'HTTP request duration in seconds',
    labelNames: ['method', 'status', 'path'],
    buckets: [0.001, 0.005, 0.01, 0.025, 0.05, 0.075, 0.1, 0.25, 0.5, 0.75, 1, 2.5, 5, 7.5, 10],
    registers: [register],
});
function metricsMiddleware(req, res, next) {
    const start = process.hrtime.bigint();
    res.on('finish', () => {
        const diffNs = Number(process.hrtime.bigint() - start);
        const seconds = diffNs / 1e9;
        const labels = {
            method: (req.method || 'GET').toUpperCase(),
            status: String(res.statusCode),
            path: req.raw?.url || req.url || 'unknown',
        };
        httpRequestsTotal.inc(labels);
        httpRequestDurationSeconds.observe(labels, seconds);
    });
    next();
}
async function renderMetrics(_req, res) {
    res.header('Content-Type', register.contentType);
    res.send(await register.metrics());
}
//# sourceMappingURL=metrics.js.map