#pragma once

#include <drogon/HttpController.h>
#include "../services/BonusService.h"
#include "../dto/BonusDTO.h"
#include <memory>

namespace controllers {

class BonusController : public drogon::HttpController<BonusController> {
public:
    BonusController() = default;
    
    METHOD_LIST_BEGIN
    ADD_METHOD_TO(BonusController::create, "/bonus", drogon::Post);
    ADD_METHOD_TO(BonusController::getOne, "/bonus/{1}", drogon::Get);
    METHOD_LIST_END
    
    void create(const drogon::HttpRequestPtr& req,
                std::function<void(const drogon::HttpResponsePtr&)>&& callback);
                
    void getOne(const drogon::HttpRequestPtr& req,
                std::function<void(const drogon::HttpResponsePtr&)>&& callback,
                int64_t id);
    
private:
    services::BonusService service_;
};

} // namespace controllers
