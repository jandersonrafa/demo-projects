import { Controller, Post, Get, Body, Param } from '@nestjs/common';
import { HttpService } from '@nestjs/axios';
import { firstValueFrom } from 'rxjs';

@Controller('bonus')
export class GatewayController {
    private readonly monolithUrl = process.env.MONOLITH_URL || 'http://localhost:3001';

    constructor(private readonly httpService: HttpService) { }

    @Post()
    async createBonus(@Body() data: any) {
        const response = await firstValueFrom(
            this.httpService.post(`${this.monolithUrl}/bonus`, data),
        );
        return response.data;
    }

    @Get('recents')
    async getRecents() {
        const response = await firstValueFrom(
            this.httpService.get(`${this.monolithUrl}/bonus/recents`),
        );
        return response.data;
    }

    @Get(':id')
    async getBonus(@Param('id') id: string) {
        const response = await firstValueFrom(
            this.httpService.get(`${this.monolithUrl}/bonus/${id}`),
        );
        return response.data;
    }
}
