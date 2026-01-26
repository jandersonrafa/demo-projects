#include <drogon/drogon.h>
#include "controllers/GatewayController.h"

int main() {
    drogon::app().loadConfigFile("config.json");
    
    // Set port from environment or default
    std::string port = std::getenv("PORT") ? std::getenv("PORT") : "3000";
    drogon::app().setThreadNum(8);
    drogon::app().setLogLevel(trantor::Logger::kInfo);
    
    drogon::app().run();
    return 0;
}
