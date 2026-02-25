#pragma once

#include "../models/Bonus.h"
#include "../dto/BonusDTO.h"
#include "../repositories/BonusRepository.h"
#include "../repositories/ClientRepository.h"
#include <memory>

namespace services {

class BonusService {
public:
    BonusService() = default;
    
    std::shared_ptr<models::Bonus> createBonus(const dto::BonusDTO& dto);
    std::shared_ptr<models::Bonus> getBonus(int64_t id);
    
private:
    repositories::BonusRepository bonusRepository_;
    repositories::ClientRepository clientRepository_;
    
    double calculateFinalAmount(double amount) const;
};

} // namespace services
