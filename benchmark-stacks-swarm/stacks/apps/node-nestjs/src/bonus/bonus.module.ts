import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { BonusService } from './services/bonus.service';
import { BonusController } from './controllers/bonus.controller';
import { Bonus } from './entities/bonus.entity';
import { Client } from './entities/client.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Bonus, Client])],
  controllers: [BonusController],
  providers: [BonusService],
  exports: [TypeOrmModule],
})
export class BonusModule { }
