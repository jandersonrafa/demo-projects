#include "../../include/repositories/BonusRepository.h"
#include "../../include/config/DatabaseConfig.h"
#include <drogon/orm/Mapper.h>
#include <chrono>

namespace repositories {

std::shared_ptr<models::Bonus> BonusRepository::create(const models::Bonus& bonus) {
    auto client = config::DatabaseConfig::getClient();
    
    try {
        std::cerr << "Creating bonus for client: " << bonus.getClientId() << std::endl;
        
        long createTime = std::chrono::system_clock::to_time_t(bonus.getCreatedAt());
        long expTime = std::chrono::system_clock::to_time_t(bonus.getExpirationDate());
        
        // Convert double to string for amount if needed, but dbClient supports double binding?
        // Postgres might need specific type. Let's try passing double directly first.
        // Update: The error 'no column named amount' suggests query structure issue.
        // Explicit INSERT string will fix it.
        
        auto f = client->execSqlAsyncFuture(
            "INSERT INTO bonus (amount, description, client_id, expiration_date, created_at) "
            "VALUES ($1, $2, $3, to_timestamp($4), to_timestamp($5)) RETURNING id",
            bonus.getAmount(), 
            bonus.getDescription(), 
            bonus.getClientId(), 
            (double)expTime, 
            (double)createTime
        );
        
        auto result = f.get();
        
        if (result.size() > 0) {
            auto newBonus = std::make_shared<models::Bonus>(bonus);
            newBonus->setId(result[0]["id"].as<int64_t>());
            std::cerr << "Bonus created with ID: " << newBonus->getId() << std::endl;
            return newBonus;
        }
        
        std::cerr << "Bonus creation failed: No ID returned" << std::endl;
        return nullptr;
    } catch (const std::exception& e) {
        std::cerr << "BonusRepository Error: " << e.what() << std::endl;
        // Print SQL error details
        const auto& drogonEx = dynamic_cast<const drogon::orm::DrogonDbException*>(&e);
        if (drogonEx) {
             // access extended info if available
        }
        return nullptr;
    } catch (...) {
        std::cerr << "BonusRepository Unknown Error" << std::endl;
        return nullptr;
    }
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
