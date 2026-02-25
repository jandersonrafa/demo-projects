#include <drogon/drogon.h>
#include "controllers/BonusController.h"
#include "config/DatabaseConfig.h"

int main() {
    drogon::app().loadConfigFile("config.json");
    drogon::app().addListener("0.0.0.0", 3000);
    
    // Initialize database
    config::DatabaseConfig::initialize();
    
    // Add simple metrics endpoint
    drogon::app().registerHandler("/actuator/prometheus",
        [](const drogon::HttpRequestPtr& req,
           std::function<void(const drogon::HttpResponsePtr&)>&& callback) {
            auto response = drogon::HttpResponse::newHttpResponse();
            response->setContentTypeCode(drogon::CT_APPLICATION_JSON);
            response->addHeader("Access-Control-Allow-Origin", "*");
            
            // Simple metrics endpoint
            std::string metrics = R"({"metrics": {"http_requests_total": 0, "http_request_duration_seconds": 0.0}})";
            response->setBody(metrics);
            callback(response);
        },
        {drogon::Get});
    
    try {
        drogon::app().run();
    } catch (const std::exception& e) {
        std::cerr << "CRITICAL ERROR: " << e.what() << std::endl;
        return 1;
    } catch (...) {
        std::cerr << "CRITICAL ERROR: Unknown exception" << std::endl;
        return 1;
    }
    return 0;
}
