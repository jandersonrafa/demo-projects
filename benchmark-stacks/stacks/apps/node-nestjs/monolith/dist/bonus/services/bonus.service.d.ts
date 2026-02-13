import { Repository } from 'typeorm';
import { Bonus } from '../entities/bonus.entity';
import { Client } from '../entities/client.entity';
import { CreateBonusDto } from '../dto/create-bonus.dto';
export declare class BonusService {
    private bonusRepository;
    private clientRepository;
    constructor(bonusRepository: Repository<Bonus>, clientRepository: Repository<Client>);
    create(bonusData: CreateBonusDto): Promise<Bonus>;
    findOne(id: number): Promise<Bonus | null>;
    getRecents(): Promise<Bonus[]>;
}
