#pragma once

#include "../models/Bonus.h"
#include <drogon/orm/Mapper.h>
#include <memory>
#include <vector>

namespace repositories {

class BonusRepository {
public:
    BonusRepository() = default;
    
    std::shared_ptr<models::Bonus> create(const models::Bonus& bonus);
    std::shared_ptr<models::Bonus> findById(int64_t id);
    std::vector<std::shared_ptr<models::Bonus>> findAll();
    bool deleteById(int64_t id);
    
private:
    std::shared_ptr<drogon::orm::Mapper<models::Bonus>> mapper_;
};

} // namespace repositories
