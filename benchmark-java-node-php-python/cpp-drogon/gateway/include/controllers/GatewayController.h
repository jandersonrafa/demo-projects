#pragma once

#include <drogon/HttpController.h>
#include <cpr/cpr.h>
#include <memory>

namespace controllers {

class GatewayController : public drogon::HttpController<GatewayController> {
public:
    METHOD_LIST_BEGIN
    ADD_METHOD_TO(GatewayController::create, "/bonus", drogon::Post);
    ADD_METHOD_TO(GatewayController::getOne, "/bonus/{1}", drogon::Get);
    METHOD_LIST_END
    
    void create(const drogon::HttpRequestPtr& req,
                std::function<void(const drogon::HttpResponsePtr&)>&& callback);
                
    void getOne(const drogon::HttpRequestPtr& req,
                std::function<void(const drogon::HttpResponsePtr&)>&& callback,
                const std::string& id);
    
private:
    std::string monolithUrl_;
    cpr::Session session_;
    
    void initializeSession();
};

} // namespace controllers
