import { BonusService } from '../services/bonus.service';
import { Bonus } from '../entities/bonus.entity';
import { CreateBonusDto } from '../dto/create-bonus.dto';
export declare class BonusController {
    private readonly bonusService;
    constructor(bonusService: BonusService);
    create(bonusData: CreateBonusDto): Promise<Bonus>;
    getRecents(): Promise<Bonus[]>;
    findOne(id: string): Promise<Bonus | null>;
}
