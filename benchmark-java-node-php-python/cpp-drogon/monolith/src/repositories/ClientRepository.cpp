#include "../../include/repositories/ClientRepository.h"
#include "../../include/config/DatabaseConfig.h"
#include <drogon/orm/Mapper.h>

namespace repositories {

std::shared_ptr<models::Client> ClientRepository::findById(const std::string& id) {
    auto client = config::DatabaseConfig::getClient();
    
    try {
        std::cerr << "Searching for client ID: " << id << std::endl;
        auto f = client->execSqlAsyncFuture("SELECT * FROM clients WHERE id = $1", id);
        auto result = f.get();
        
        if (result.size() == 0) {
            std::cerr << "Client not found in DB" << std::endl;
            return nullptr;
        }
        
        std::cerr << "Found client row, creating object" << std::endl;
        return std::make_shared<models::Client>(result[0]);
    } catch (const std::exception& e) {
        std::cerr << "ClientRepository Error: " << e.what() << std::endl;
        return nullptr;
    } catch (...) {
        std::cerr << "ClientRepository Unknown Error" << std::endl;
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
