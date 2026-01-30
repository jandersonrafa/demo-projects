package main

import (
	"log"
	"monolith/internal/config"
	"monolith/internal/handler"
	"monolith/internal/repository"
	"monolith/internal/service"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	db := config.InitDB()

	// Initialize layers
	bonusRepo := repository.NewBonusRepository(db)
	clientRepo := repository.NewClientRepository(db)
	bonusService := service.NewBonusService(bonusRepo, clientRepo)
	bonusHandler := handler.NewBonusHandler(bonusService)

	r := gin.New()
	r.Use(gin.Recovery())

	// Prometheus metrics endpoint
	r.GET("/metrics", gin.WrapH(promhttp.Handler()))

	// Bonus routes
	bonusGroup := r.Group("/bonus")
	{
		bonusGroup.POST("", bonusHandler.Create)
		bonusGroup.GET("/:id", bonusHandler.GetOne)
	}

	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	log.Printf("Server starting on port %s", port)
	if err := r.Run(":" + port); err != nil {
		log.Fatalf("Failed to run server: %v", err)
	}
}
