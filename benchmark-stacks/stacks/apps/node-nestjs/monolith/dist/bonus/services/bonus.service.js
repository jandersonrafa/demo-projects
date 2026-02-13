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
exports.BonusService = void 0;
const common_1 = require("@nestjs/common");
const typeorm_1 = require("@nestjs/typeorm");
const typeorm_2 = require("typeorm");
const bonus_entity_1 = require("../entities/bonus.entity");
const client_entity_1 = require("../entities/client.entity");
let BonusService = class BonusService {
    bonusRepository;
    clientRepository;
    constructor(bonusRepository, clientRepository) {
        this.bonusRepository = bonusRepository;
        this.clientRepository = clientRepository;
    }
    async create(bonusData) {
        const client = await this.clientRepository.findOneBy({ id: bonusData.clientId });
        if (!client) {
            throw new common_1.NotFoundException(`Client with ID ${bonusData.clientId} not found`);
        }
        if (!client.active) {
            throw new common_1.BadRequestException(`Client ${bonusData.clientId} is inactive`);
        }
        let amount = bonusData.amount;
        if (amount > 100) {
            amount = amount * 1.1;
        }
        const expirationDate = new Date();
        expirationDate.setDate(expirationDate.getDate() + 30);
        bonusData.description = "NODENESTJS - " + bonusData.description;
        const bonus = this.bonusRepository.create({
            ...bonusData,
            amount,
            expirationDate,
        });
        return this.bonusRepository.save(bonus);
    }
    findOne(id) {
        return this.bonusRepository.findOneBy({ id });
    }
    async getRecents() {
        const bonuses = await this.bonusRepository.find({
            order: { id: 'ASC' },
            take: 100
        });
        return bonuses
            .sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime())
            .slice(0, 10);
    }
};
exports.BonusService = BonusService;
exports.BonusService = BonusService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, typeorm_1.InjectRepository)(bonus_entity_1.Bonus)),
    __param(1, (0, typeorm_1.InjectRepository)(client_entity_1.Client)),
    __metadata("design:paramtypes", [typeorm_2.Repository,
        typeorm_2.Repository])
], BonusService);
//# sourceMappingURL=bonus.service.js.map