#include "../../include/services/BonusService.h"
#include "../../include/repositories/BonusRepository.h"
#include "../../include/repositories/ClientRepository.h"
#include <chrono>
#include <stdexcept>

namespace services {

std::shared_ptr<models::Bonus> BonusService::createBonus(const dto::BonusDTO& dto) {
    // Validate input
    if (!dto.isValid()) {
        throw std::invalid_argument(dto.getValidationError());
    }
    
    // Check if client exists and is active
    auto client = clientRepository_.findById(dto.clientId);
    if (!client) {
        throw std::runtime_error("Client not found");
    }
    
    if (!client->getActive()) {
        throw std::runtime_error("Client is inactive");
    }
    
    // Calculate final amount with business logic
    double finalAmount = calculateFinalAmount(dto.amount);
    
    // Create bonus entity
    models::Bonus bonus;
    bonus.setAmount(finalAmount);
    bonus.setDescription("CPPDROGON - " + dto.description);
    bonus.setClientId(dto.clientId);
    bonus.setCreatedAt(std::chrono::system_clock::now());
    bonus.setExpirationDate(std::chrono::system_clock::now() + std::chrono::hours(30 * 24)); // 30 days
    
    return bonusRepository_.create(bonus);
}

std::shared_ptr<models::Bonus> BonusService::getBonus(int64_t id) {
    return bonusRepository_.findById(id);
}

double BonusService::calculateFinalAmount(double amount) const {
    if (amount > 100.0) {
        return amount * 1.1; // 10% bonus for amounts > 100
    }
    return amount;
}

} // namespace services
