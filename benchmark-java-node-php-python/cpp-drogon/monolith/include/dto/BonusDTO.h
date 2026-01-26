#pragma once

#include <string>
#include <drogon/HttpController.h>

namespace dto {

struct BonusDTO {
    double amount;
    std::string description;
    std::string clientId;
    
    // Validation methods
    bool isValid() const {
        return amount >= 0 && !description.empty() && !clientId.empty();
    }
    
    std::string getValidationError() const {
        if (amount < 0) return "Amount must be positive";
        if (description.empty()) return "Description is required";
        if (clientId.empty()) return "ClientId is required";
        return "";
    }
};

} // namespace dto
