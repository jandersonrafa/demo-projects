#pragma once

#include <drogon/orm/Mapper.h>
#include <drogon/orm/Result.h>
#include <drogon/orm/Row.h>
#include <memory>
#include <string>
#include <chrono>

namespace models {

class Bonus {
public:
    Bonus() = default;
    Bonus(const drogon::orm::Row& row) {
        id_ = row["id"].as<int64_t>();
        amount_ = row["amount"].as<double>();
        description_ = row["description"].as<std::string>();
        clientId_ = row["client_id"].as<std::string>();
        expirationDate_ = std::chrono::system_clock::from_time_t(row["expiration_date"].as<time_t>());
        createdAt_ = std::chrono::system_clock::from_time_t(row["created_at"].as<time_t>());
    }
    
    int64_t getId() const { return id_; }
    void setId(int64_t id) { id_ = id; }
    
    double getAmount() const { return amount_; }
    void setAmount(double amount) { amount_ = amount; }
    
    const std::string& getDescription() const { return description_; }
    void setDescription(const std::string& description) { description_ = description; }
    
    const std::string& getClientId() const { return clientId_; }
    void setClientId(const std::string& clientId) { clientId_ = clientId; }
    
    std::chrono::system_clock::time_point getExpirationDate() const { return expirationDate_; }
    void setExpirationDate(const std::chrono::system_clock::time_point& date) { expirationDate_ = date; }
    
    std::chrono::system_clock::time_point getCreatedAt() const { return createdAt_; }
    void setCreatedAt(const std::chrono::system_clock::time_point& date) { createdAt_ = date; }
    
    // Static methods for ORM mapping
    static constexpr const char tableName[] = "bonus";
    static constexpr const char primaryKeyName[] = "id";
    using PrimaryKeyType = int64_t;

    static std::string sqlForFindingByPrimaryKey() {
        return "SELECT * FROM bonus WHERE id = $1";
    }

    static std::string sqlForDeletingByPrimaryKey() {
        return "DELETE FROM bonus WHERE id = $1";
    }

    std::string sqlForUpdatingByPrimaryKey() const {
        return "UPDATE bonus SET amount = $1, description = $2, client_id = $3, expiration_date = $4, created_at = $5 WHERE id = $6";
    }

    template<typename T>
    void updateArgs(T& binder) const {
        auto expTime = std::chrono::system_clock::to_time_t(expirationDate_);
        auto createTime = std::chrono::system_clock::to_time_t(createdAt_);
        binder << amount_ << description_ << clientId_ << expTime << createTime << id_;
    }
    
    // Required ORM methods
    std::string sqlForInserting(bool& needSelection) const {
        needSelection = true;
        return "INSERT INTO bonus (amount, description, client_id, expiration_date, created_at) VALUES ($1, $2, $3, $4, $5) RETURNING id";
    }
    
    template<typename T>
    void outputArgs(T& binder) const {
        auto expTime = std::chrono::system_clock::to_time_t(expirationDate_);
        auto createTime = std::chrono::system_clock::to_time_t(createdAt_);
        binder << amount_ << description_ << clientId_ << expTime << createTime;
    }
    
    void updateId(int64_t id) {
        id_ = id;
    }
    
    int64_t getPrimaryKey() const {
        return id_;
    }
    
    // Mapper for database operations
    using Mapper = drogon::orm::Mapper<Bonus>;
    
private:
    int64_t id_{0};
    double amount_{0.0};
    std::string description_;
    std::string clientId_;
    std::chrono::system_clock::time_point expirationDate_;
    std::chrono::system_clock::time_point createdAt_;
};

} // namespace models
