package main

import (
	"gateway/internal/handler"
	"gateway/internal/infra"
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	monolithURL := os.Getenv("MONOLITH_URL")
	if monolithURL == "" {
		monolithURL = "http://localhost:3000"
	}

	httpClient := infra.NewHTTPClient()
	proxyHandler := handler.NewProxyHandler(monolithURL, httpClient)

	if os.Getenv("GIN_MODE") != "debug" {
		gin.SetMode(gin.ReleaseMode)
	}
	r := gin.New()
	r.Use(gin.Recovery())

	// Prometheus metrics endpoint
	r.GET("/metrics", gin.WrapH(promhttp.Handler()))

	// Proxy routes
	r.POST("/bonus", proxyHandler.ProxyPost)
	r.GET("/bonus/recents", proxyHandler.ProxyRecents)
	r.GET("/bonus/:id", proxyHandler.ProxyGet)

	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	log.Printf("Gateway starting on port %s, proxying to %s", port, monolithURL)
	if err := r.Run(":" + port); err != nil {
		log.Fatalf("Failed to run gateway: %v", err)
	}
}
