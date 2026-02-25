#pragma once

#include <drogon/orm/DbClient.h>
#include <string>

namespace config {

class DatabaseConfig {
public:
    static void initialize();
    static std::shared_ptr<drogon::orm::DbClient> getClient();
    
private:
    static std::shared_ptr<drogon::orm::DbClient> dbClient_;
    static std::string getConnectionString();
};

} // namespace config
