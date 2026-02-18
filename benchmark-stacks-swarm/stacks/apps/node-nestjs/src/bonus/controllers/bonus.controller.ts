import { Controller, Post, Get, Body, Param, HttpCode, HttpStatus } from '@nestjs/common';
import { BonusService } from '../services/bonus.service';
import { Bonus } from '../entities/bonus.entity';
import { CreateBonusDto } from '../dto/create-bonus.dto';

@Controller('bonus')
export class BonusController {
    constructor(private readonly bonusService: BonusService) { }

    @Post()
    @HttpCode(HttpStatus.CREATED)
    create(@Body() bonusData: CreateBonusDto): Promise<Bonus> {
        return this.bonusService.create(bonusData);
    }

    @Get('recents')
    getRecents(): Promise<Bonus[]> {
        return this.bonusService.getRecents();
    }

    @Get(':id')
    findOne(@Param('id') id: string): Promise<Bonus | null> {
        return this.bonusService.findOne(+id);
    }
}
