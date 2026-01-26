#include "../../include/config/DatabaseConfig.h"
#include <drogon/drogon.h>
#include <cstdlib>

namespace config {

std::shared_ptr<drogon::orm::DbClient> DatabaseConfig::dbClient_ = nullptr;

void DatabaseConfig::initialize() {
    if (!dbClient_) {
        std::string connStr = getConnectionString();
        dbClient_ = drogon::orm::DbClient::newPgClient(connStr, 1);
    }
}

std::shared_ptr<drogon::orm::DbClient> DatabaseConfig::getClient() {
    if (!dbClient_) {
        initialize();
    }
    return dbClient_;
}

std::string DatabaseConfig::getConnectionString() {
    const char* host = std::getenv("DB_HOST");
    const char* port = std::getenv("DB_PORT");
    const char* user = std::getenv("DB_USER");
    const char* password = std::getenv("DB_PASSWORD");
    const char* dbname = std::getenv("DB_NAME");
    
    std::string connStr = "host=";
    connStr += host ? host : "localhost";
    connStr += " port=";
    connStr += port ? port : "5432";
    connStr += " dbname=";
    connStr += dbname ? dbname : "benchmark";
    connStr += " user=";
    connStr += user ? user : "cpp_user";
    connStr += " password=";
    connStr += password ? password : "cpp_pass";
    
    return connStr;
}

} // namespace config
