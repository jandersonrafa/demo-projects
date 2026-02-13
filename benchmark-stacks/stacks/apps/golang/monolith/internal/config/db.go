package config

import (
	"fmt"
	"log"
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func InitDB() *gorm.DB {
	dbHost := os.Getenv("DB_HOST")
	dbPort := os.Getenv("DB_PORT")
	dbUser := os.Getenv("DB_USER")
	dbPass := os.Getenv("DB_PASSWORD")
	dbName := os.Getenv("DB_NAME")
	if dbName == "" {
		dbName = "benchmark"
	}

	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable",
		dbHost, dbUser, dbPass, dbName, dbPort)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("failed to connect database: %v", err)
	}

	sqlDB, err := db.DB()
	if err != nil {
		log.Fatalf("failed to get sql.DB: %v", err)
	}

	sqlDB.SetMaxOpenConns(15)
	sqlDB.SetMaxIdleConns(15)
	if maxPoolSize := os.Getenv("DB_MAX_POOL_SIZE"); maxPoolSize != "" {
		var n int
		if _, err := fmt.Sscanf(maxPoolSize, "%d", &n); err == nil {
			sqlDB.SetMaxOpenConns(n)
			sqlDB.SetMaxIdleConns(n)
		}
	}

	return db
}
