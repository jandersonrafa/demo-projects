#include "../../include/controllers/BonusController.h"
#include <drogon/HttpTypes.h>
#include <drogon/HttpRequest.h>
#include <drogon/HttpResponse.h>
#include <json/json.h>
#include <stdexcept>

namespace controllers {

void BonusController::create(const drogon::HttpRequestPtr& req,
                            std::function<void(const drogon::HttpResponsePtr&)>&& callback) {
    auto response = drogon::HttpResponse::newHttpResponse();
    
    try {
        // Parse JSON from request body
        auto json = req->getJsonObject();
        if (!json) {
            Json::Value error;
            error["error"] = "Invalid JSON";
            response->setBody(error.toStyledString());
            response->setContentTypeCode(drogon::CT_APPLICATION_JSON);
            response->setStatusCode(drogon::k400BadRequest);
            callback(response);
            return;
        }
        
        // Create DTO from JSON
        dto::BonusDTO dto;
        dto.amount = (*json)["amount"].asDouble();
        dto.description = (*json)["description"].asString();
        dto.clientId = (*json)["clientId"].asString();
        
        // Validate
        if (!dto.isValid()) {
            Json::Value error;
            error["error"] = dto.getValidationError();
            response->setBody(error.toStyledString());
            response->setContentTypeCode(drogon::CT_APPLICATION_JSON);
            response->setStatusCode(drogon::k400BadRequest);
            callback(response);
            return;
        }
        
        auto bonus = service_.createBonus(dto);
        
        // Convert bonus to JSON
        Json::Value json_response;
        json_response["id"] = static_cast<int64_t>(bonus->getId());
        json_response["amount"] = bonus->getAmount();
        json_response["description"] = bonus->getDescription();
        json_response["clientId"] = bonus->getClientId();
        
        // Convert time points to timestamps
        auto createdTime = std::chrono::system_clock::to_time_t(bonus->getCreatedAt());
        auto expTime = std::chrono::system_clock::to_time_t(bonus->getExpirationDate());
        
        json_response["createdAt"] = static_cast<int64_t>(createdTime);
        json_response["expirationDate"] = static_cast<int64_t>(expTime);
        
        response->setBody(json_response.toStyledString());
        response->setContentTypeCode(drogon::CT_APPLICATION_JSON);
        response->setStatusCode(drogon::k201Created);
        
    } catch (const std::exception& e) {
        Json::Value error;
        error["error"] = e.what();
        response->setBody(error.toStyledString());
        response->setContentTypeCode(drogon::CT_APPLICATION_JSON);
        response->setStatusCode(drogon::k400BadRequest);
    }
    
    callback(response);
}

void BonusController::getOne(const drogon::HttpRequestPtr& req,
                           std::function<void(const drogon::HttpResponsePtr&)>&& callback,
                           int64_t id) {
    auto response = drogon::HttpResponse::newHttpResponse();
    
    auto bonus = service_.getBonus(id);
    
    if (!bonus) {
        Json::Value error;
        error["error"] = "Bonus not found";
        response->setBody(error.toStyledString());
        response->setContentTypeCode(drogon::CT_APPLICATION_JSON);
        response->setStatusCode(drogon::k404NotFound);
        callback(response);
        return;
    }
    
    // Convert bonus to JSON
    Json::Value json;
    json["id"] = static_cast<int64_t>(bonus->getId());
    json["amount"] = bonus->getAmount();
    json["description"] = bonus->getDescription();
    json["clientId"] = bonus->getClientId();
    
    // Convert time points to timestamps
    auto createdTime = std::chrono::system_clock::to_time_t(bonus->getCreatedAt());
    auto expTime = std::chrono::system_clock::to_time_t(bonus->getExpirationDate());
    
    json["createdAt"] = static_cast<int64_t>(createdTime);
    json["expirationDate"] = static_cast<int64_t>(expTime);
    
    response->setBody(json.toStyledString());
    response->setContentTypeCode(drogon::CT_APPLICATION_JSON);
    response->setStatusCode(drogon::k200OK);
    
    callback(response);
}

} // namespace controllers
