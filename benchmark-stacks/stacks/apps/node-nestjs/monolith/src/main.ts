import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';
import { metricsMiddleware, renderMetrics } from './metrics';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    forbidNonWhitelisted: true,
    transform: true,
  }));
  app.use(metricsMiddleware);

  const httpAdapter = app.getHttpAdapter();
  const server = httpAdapter.getInstance();
  if (server && typeof server.get === 'function') {
    server.get('/metrics', renderMetrics);
  }
  await app.listen(process.env.PORT ?? 3001);
  console.log(`Monolith is running on: ${await app.getUrl()}`);
}
bootstrap();
