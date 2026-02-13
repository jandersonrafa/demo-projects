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
exports.BonusController = void 0;
const common_1 = require("@nestjs/common");
const bonus_service_1 = require("../services/bonus.service");
const create_bonus_dto_1 = require("../dto/create-bonus.dto");
let BonusController = class BonusController {
    bonusService;
    constructor(bonusService) {
        this.bonusService = bonusService;
    }
    create(bonusData) {
        return this.bonusService.create(bonusData);
    }
    getRecents() {
        return this.bonusService.getRecents();
    }
    findOne(id) {
        return this.bonusService.findOne(+id);
    }
};
exports.BonusController = BonusController;
__decorate([
    (0, common_1.Post)(),
    (0, common_1.HttpCode)(common_1.HttpStatus.CREATED),
    __param(0, (0, common_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_bonus_dto_1.CreateBonusDto]),
    __metadata("design:returntype", Promise)
], BonusController.prototype, "create", null);
__decorate([
    (0, common_1.Get)('recents'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], BonusController.prototype, "getRecents", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], BonusController.prototype, "findOne", null);
exports.BonusController = BonusController = __decorate([
    (0, common_1.Controller)('bonus'),
    __metadata("design:paramtypes", [bonus_service_1.BonusService])
], BonusController);
//# sourceMappingURL=bonus.controller.js.map