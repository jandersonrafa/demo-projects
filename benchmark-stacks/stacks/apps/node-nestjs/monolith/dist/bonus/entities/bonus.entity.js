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
Object.defineProperty(exports, "__esModule", { value: true });
exports.Bonus = void 0;
const typeorm_1 = require("typeorm");
let Bonus = class Bonus {
    id;
    amount;
    description;
    clientId;
    createdAt;
    expirationDate;
};
exports.Bonus = Bonus;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Bonus.prototype, "id", void 0);
__decorate([
    (0, typeorm_1.Column)({
        type: 'decimal',
        precision: 15,
        scale: 2,
        transformer: {
            to: (value) => value,
            from: (value) => value !== null ? parseFloat(value) : null
        }
    }),
    __metadata("design:type", Number)
], Bonus.prototype, "amount", void 0);
__decorate([
    (0, typeorm_1.Column)(),
    __metadata("design:type", String)
], Bonus.prototype, "description", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'client_id' }),
    __metadata("design:type", String)
], Bonus.prototype, "clientId", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)({ name: 'created_at' }),
    __metadata("design:type", Date)
], Bonus.prototype, "createdAt", void 0);
__decorate([
    (0, typeorm_1.Column)({ name: 'expiration_date', nullable: true }),
    __metadata("design:type", Date)
], Bonus.prototype, "expirationDate", void 0);
exports.Bonus = Bonus = __decorate([
    (0, typeorm_1.Entity)()
], Bonus);
//# sourceMappingURL=bonus.entity.js.map