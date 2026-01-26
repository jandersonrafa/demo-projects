#include "../../include/controllers/GatewayController.h"
#include <drogon/HttpTypes.h>
#include <drogon/HttpRequest.h>
#include <drogon/HttpResponse.h>
#include <cstdlib>

namespace controllers {

GatewayController::GatewayController() {
    initializeSession();
}

void GatewayController::initializeSession() {
    monolithUrl_ = std::getenv("MONOLITH_URL") ? std::getenv("MONOLITH_URL") : "http://localhost:3000";
    
    // Configure session
    session_.SetUrl(cpr::Url{monolithUrl_});
    session_.SetTimeout(cpr::Timeout{30000}); // 30 seconds
    session_.SetConnectTimeout(cpr::ConnectTimeout{10000}); // 10 seconds
}

void GatewayController::create(const drogon::HttpRequestPtr& req,
                              std::function<void(const drogon::HttpResponsePtr&)>&& callback) {
    auto response = drogon::HttpResponse::newHttpResponse();
    
    try {
        // Forward the request to monolith
        std::string requestBody(req->getBody());
        std::string fullUrl = monolithUrl_ + "/bonus";
        
        auto r = cpr::Post(cpr::Url{fullUrl},
                          cpr::Body{requestBody},
                          cpr::Header{{"Content-Type", "application/json"},
                                      {"Accept", "application/json"}});
        
        response->setBody(r.text);
        response->setStatusCode(static_cast<drogon::HttpStatusCode>(r.status_code));
        
        // Copy headers from response
        for (const auto& header : r.header) {
            response->addHeader(header.first, header.second);
        }
        
    } catch (const std::exception& e) {
        std::string error = R"({"error": ")" + std::string(e.what()) + R"("})";
        response->setBody(error);
        response->setStatusCode(drogon::k500InternalServerError);
        response->setContentTypeCode(drogon::CT_APPLICATION_JSON);
    }
    
    callback(response);
}

void GatewayController::getOne(const drogon::HttpRequestPtr& req,
                              std::function<void(const drogon::HttpResponsePtr&)>&& callback,
                              const std::string& id) {
    auto response = drogon::HttpResponse::newHttpResponse();
    
    try {
        std::string fullUrl = monolithUrl_ + "/bonus/" + id;
        
        auto r = cpr::Get(cpr::Url{fullUrl},
                         cpr::Header{{"Accept", "application/json"}});
        
        response->setBody(r.text);
        response->setStatusCode(static_cast<drogon::HttpStatusCode>(r.status_code));
        
        // Copy headers from response
        for (const auto& header : r.header) {
            response->addHeader(header.first, header.second);
        }
        
    } catch (const std::exception& e) {
        std::string error = R"({"error": ")" + std::string(e.what()) + R"("})";
        response->setBody(error);
        response->setStatusCode(drogon::k500InternalServerError);
        response->setContentTypeCode(drogon::CT_APPLICATION_JSON);
    }
    
    callback(response);
}

} // namespace controllers
