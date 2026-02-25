import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BonusModule } from './bonus/bonus.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT ?? '6432'),
      username: process.env.DB_USER || 'postgres',
      password: process.env.DB_PASSWORD || 'postgres',
      database: process.env.DB_NAME || 'benchmark',
      autoLoadEntities: true,
      synchronize: false,
      extra: {
        max: parseInt(process.env.DB_MAX_POOL_SIZE ?? '15'),
        application_name: 'node-nest-fastify',
      },
    }),
    BonusModule,
  ],
})
export class AppModule {}
