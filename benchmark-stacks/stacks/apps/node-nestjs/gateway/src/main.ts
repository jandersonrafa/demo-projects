import { NestFactory } from '@nestjs/core';
import {
  FastifyAdapter,
  NestFastifyApplication,
} from '@nestjs/platform-fastify';
import { AppModule } from './app.module';
import { metricsMiddleware, renderMetrics } from './metrics';

async function bootstrap() {
  const app = await NestFactory.create<NestFastifyApplication>(
    AppModule,
    new FastifyAdapter(),
  );
  app.use(metricsMiddleware);

  const httpAdapter = app.getHttpAdapter();
  const server = httpAdapter.getInstance();
  if (server && typeof server.get === 'function') {
    server.get('/metrics', renderMetrics);
  }
  await app.listen(process.env.PORT ?? 3000, '0.0.0.0');
  console.log(`Gateway is running on: ${await app.getUrl()}`);
}
bootstrap();
