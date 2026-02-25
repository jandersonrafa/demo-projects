import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Bonus } from '../entities/bonus.entity';
import { Client } from '../entities/client.entity';
import { CreateBonusDto } from '../dto/create-bonus.dto';

@Injectable()
export class BonusService {
  constructor(
    @InjectRepository(Bonus)
    private bonusRepository: Repository<Bonus>,
    @InjectRepository(Client)
    private clientRepository: Repository<Client>,
  ) {}

  async create(bonusData: CreateBonusDto): Promise<Bonus> {
    const client = await this.clientRepository.findOneBy({ id: bonusData.clientId });
    if (!client) {
      throw new NotFoundException(`Client with ID ${bonusData.clientId} not found`);
    }

    if (!client.active) {
      throw new BadRequestException(`Client ${bonusData.clientId} is inactive`);
    }

    let amount = bonusData.amount;
    if (amount > 100) {
      amount = amount * 1.1;
    }

    const expirationDate = new Date();
    expirationDate.setDate(expirationDate.getDate() + 30);

    bonusData.description = 'NODENESTJS - ' + bonusData.description;
    const bonus = this.bonusRepository.create({
      ...bonusData,
      amount,
      expirationDate,
    });

    return this.bonusRepository.save(bonus);
  }

  findOne(id: number): Promise<Bonus | null> {
    return this.bonusRepository.findOneBy({ id });
  }

  async getRecents(): Promise<Bonus[]> {
    const bonuses = await this.bonusRepository.find({
      order: { id: 'ASC' } as any,
      take: 100,
    });

    return bonuses
      .sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime())
      .slice(0, 10);
  }
}
