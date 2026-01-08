import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BonusModule } from './bonus/bonus.module';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';

@Module({
  imports: [
    PrometheusModule.register(),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST || 'localhost',
      port: parseInt(process.env.DB_PORT ?? '5432'),
      username: process.env.DB_USER || 'postgres',
      password: process.env.DB_PASSWORD || 'postgres',
      database: process.env.DB_NAME || 'benchmark',
      autoLoadEntities: true,
      synchronize: false, // For benchmark purposes
      // Pool configuration: pass 'extra' to underlying pg driver
      extra: { max: 15, application_name: 'node-nest' },
    }),
    BonusModule,
  ],
})
export class AppModule { }
