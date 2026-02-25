#pragma once

#include "../models/Client.h"
#include <drogon/orm/Mapper.h>
#include <memory>
#include <vector>

namespace repositories {

class ClientRepository {
public:
    ClientRepository() = default;
    
    std::shared_ptr<models::Client> findById(const std::string& id);
    std::vector<std::shared_ptr<models::Client>> findAll();
    std::shared_ptr<models::Client> create(const models::Client& client);
    
private:
    std::shared_ptr<drogon::orm::Mapper<models::Client>> mapper_;
};

} // namespace repositories
