#include "../../include/repositories/ClientRepository.h"
#include "../../include/config/DatabaseConfig.h"
#include <drogon/orm/Mapper.h>

namespace repositories {

std::shared_ptr<models::Client> ClientRepository::findById(const std::string& id) {
    auto client = config::DatabaseConfig::getClient();
    auto mapper = std::make_shared<drogon::orm::Mapper<models::Client>>(client);
    
    try {
        auto result = mapper->findFutureBy([&id](const drogon::orm::CriteriaBuilder& cb) {
            return cb.Criteria("id", drogon::orm::CompareOperator::EQ, id);
        }).get();
        
        if (!result.empty()) {
            return std::make_shared<models::Client>(result[0]);
        }
        return nullptr;
    } catch (...) {
        return nullptr;
    }
}

std::vector<std::shared_ptr<models::Client>> ClientRepository::findAll() {
    auto client = config::DatabaseConfig::getClient();
    auto mapper = std::make_shared<drogon::orm::Mapper<models::Client>>(client);
    
    std::vector<std::shared_ptr<models::Client>> clients;
    // Use findBy with empty criteria instead of findAll to avoid tableName issues
    try {
        auto results = mapper->findBy(drogon::orm::Criteria());
        for (const auto& clientObj : results) {
            clients.push_back(std::make_shared<models::Client>(clientObj));
        }
    } catch (...) {
        // If findBy fails, return empty vector
    }
    
    return clients;
}

std::shared_ptr<models::Client> ClientRepository::create(const models::Client& client) {
    auto dbClient = config::DatabaseConfig::getClient();
    auto mapper = std::make_shared<drogon::orm::Mapper<models::Client>>(dbClient);
    
    auto newClient = std::make_shared<models::Client>(client);
    mapper->insert(*newClient);
    
    return newClient;
}

} // namespace repositories
