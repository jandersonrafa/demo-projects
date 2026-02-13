"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const core_1 = require("@nestjs/core");
const platform_fastify_1 = require("@nestjs/platform-fastify");
const common_1 = require("@nestjs/common");
const app_module_1 = require("./app.module");
const metrics_1 = require("./metrics");
async function bootstrap() {
    const app = await core_1.NestFactory.create(app_module_1.AppModule, new platform_fastify_1.FastifyAdapter());
    app.useGlobalPipes(new common_1.ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
    }));
    app.use(metrics_1.metricsMiddleware);
    const httpAdapter = app.getHttpAdapter();
    const server = httpAdapter.getInstance();
    if (server && typeof server.get === 'function') {
        server.get('/metrics', metrics_1.renderMetrics);
    }
    await app.listen(process.env.PORT ?? 3001, '0.0.0.0');
    console.log(`Monolith is running on: ${await app.getUrl()}`);
}
bootstrap();
//# sourceMappingURL=main.js.map