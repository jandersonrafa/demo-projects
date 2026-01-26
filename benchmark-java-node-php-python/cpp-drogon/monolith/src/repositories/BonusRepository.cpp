#include "../../include/repositories/BonusRepository.h"
#include "../../include/config/DatabaseConfig.h"
#include <drogon/orm/Mapper.h>
#include <chrono>

namespace repositories {

std::shared_ptr<models::Bonus> BonusRepository::create(const models::Bonus& bonus) {
    auto client = config::DatabaseConfig::getClient();
    auto mapper = std::make_shared<drogon::orm::Mapper<models::Bonus>>(client);
    
    auto newBonus = std::make_shared<models::Bonus>(bonus);
    mapper->insert(*newBonus);
    
    return newBonus;
}

std::shared_ptr<models::Bonus> BonusRepository::findById(int64_t id) {
    auto client = config::DatabaseConfig::getClient();
    auto mapper = std::make_shared<drogon::orm::Mapper<models::Bonus>>(client);
    
    try {
        auto bonus = std::make_shared<models::Bonus>(mapper->findByPrimaryKey(id));
        return bonus;
    } catch (...) {
        return nullptr;
    }
}

std::vector<std::shared_ptr<models::Bonus>> BonusRepository::findAll() {
    auto client = config::DatabaseConfig::getClient();
    auto mapper = std::make_shared<drogon::orm::Mapper<models::Bonus>>(client);
    
    std::vector<std::shared_ptr<models::Bonus>> bonuses;
    // Use findBy with empty criteria instead of findAll to avoid tableName issues
    try {
        auto results = mapper->findBy(drogon::orm::Criteria());
        for (const auto& bonus : results) {
            bonuses.push_back(std::make_shared<models::Bonus>(bonus));
        }
    } catch (...) {
        // If findBy fails, return empty vector
    }
    
    return bonuses;
}

bool BonusRepository::deleteById(int64_t id) {
    auto client = config::DatabaseConfig::getClient();
    auto mapper = std::make_shared<drogon::orm::Mapper<models::Bonus>>(client);
    
    try {
        mapper->deleteByPrimaryKey(id);
        return true;
    } catch (...) {
        return false;
    }
}

} // namespace repositories
