#pragma once

#include <string>
#include <drogon/orm/Mapper.h>

namespace models {

class Client {
public:
    Client() = default;
    Client(const drogon::orm::Row& row) {
        id_ = row["id"].as<std::string>();
        active_ = row["active"].as<bool>();
        name_ = row["name"].as<std::string>();
    }
    
    const std::string& getId() const { return id_; }
    void setId(const std::string& id) { id_ = id; }
    
    bool getActive() const { return active_; }
    void setActive(bool active) { active_ = active; }
    
    const std::string& getName() const { return name_; }
    void setName(const std::string& name) { name_ = name; }
    
    // Static methods for ORM mapping
    static constexpr const char tableName[] = "clients";
    static constexpr const char primaryKeyName[] = "id";
    using PrimaryKeyType = std::string;

    static std::string sqlForFindingByPrimaryKey() {
        return "SELECT * FROM clients WHERE id = $1";
    }

    static std::string sqlForDeletingByPrimaryKey() {
        return "DELETE FROM clients WHERE id = $1";
    }

    std::string sqlForUpdatingByPrimaryKey() const {
        return "UPDATE clients SET active = $1, name = $2 WHERE id = $3";
    }

    template<typename T>
    void updateArgs(T& binder) const {
        binder << active_ << name_ << id_;
    }
    
    // Required ORM methods
    std::string sqlForInserting(bool& needSelection) const {
        needSelection = false;
        return "INSERT INTO clients (id, active, name) VALUES ($1, $2, $3)";
    }
    
    template<typename T>
    void outputArgs(T& binder) const {
        binder << id_ << active_ << name_;
    }
    
    void updateId(uint64_t id) {
        // For clients table, id is VARCHAR and provided manually.
    }
    
    std::string getPrimaryKey() const {
        return id_;
    }
    
    // Mapper for database operations
    using Mapper = drogon::orm::Mapper<Client>;
    
private:
    std::string id_;
    bool active_{true};
    std::string name_;
};

} // namespace models
