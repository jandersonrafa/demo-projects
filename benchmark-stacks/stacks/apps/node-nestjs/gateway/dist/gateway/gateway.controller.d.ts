import { HttpService } from '@nestjs/axios';
export declare class GatewayController {
    private readonly httpService;
    private readonly monolithUrl;
    constructor(httpService: HttpService);
    createBonus(data: any): Promise<any>;
    getRecents(): Promise<any>;
    getBonus(id: string): Promise<any>;
}
