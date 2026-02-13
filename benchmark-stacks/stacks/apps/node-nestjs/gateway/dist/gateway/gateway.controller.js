"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.GatewayController = void 0;
const common_1 = require("@nestjs/common");
const axios_1 = require("@nestjs/axios");
const rxjs_1 = require("rxjs");
let GatewayController = class GatewayController {
    httpService;
    monolithUrl = process.env.MONOLITH_URL || 'http://localhost:3001';
    constructor(httpService) {
        this.httpService = httpService;
    }
    async createBonus(data) {
        const response = await (0, rxjs_1.firstValueFrom)(this.httpService.post(`${this.monolithUrl}/bonus`, data));
        return response.data;
    }
    async getRecents() {
        const response = await (0, rxjs_1.firstValueFrom)(this.httpService.get(`${this.monolithUrl}/bonus/recents`));
        return response.data;
    }
    async getBonus(id) {
        const response = await (0, rxjs_1.firstValueFrom)(this.httpService.get(`${this.monolithUrl}/bonus/${id}`));
        return response.data;
    }
};
exports.GatewayController = GatewayController;
__decorate([
    (0, common_1.Post)(),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], GatewayController.prototype, "createBonus", null);
__decorate([
    (0, common_1.Get)('recents'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], GatewayController.prototype, "getRecents", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], GatewayController.prototype, "getBonus", null);
exports.GatewayController = GatewayController = __decorate([
    (0, common_1.Controller)('bonus'),
    __metadata("design:paramtypes", [axios_1.HttpService])
], GatewayController);
//# sourceMappingURL=gateway.controller.js.map