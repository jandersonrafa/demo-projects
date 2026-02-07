package handler

import (
	"bytes"
	"io/ioutil"
	"net/http"

	"github.com/gin-gonic/gin"
)

type ProxyHandler struct {
	monolithURL string
	httpClient  *http.Client
}

func NewProxyHandler(monolithURL string, httpClient *http.Client) *ProxyHandler {
	return &ProxyHandler{monolithURL, httpClient}
}

func (h *ProxyHandler) ProxyPost(c *gin.Context) {
	body, err := ioutil.ReadAll(c.Request.Body)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to read request body"})
		return
	}

	req, err := http.NewRequest("POST", h.monolithURL+"/bonus", bytes.NewBuffer(body))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create request"})
		return
	}
	req.Header.Set("Content-Type", "application/json")

	resp, err := h.httpClient.Do(req)
	if err != nil {
		c.JSON(http.StatusBadGateway, gin.H{"error": "Failed to connect to monolith"})
		return
	}
	defer resp.Body.Close()

	respBody, _ := ioutil.ReadAll(resp.Body)
	c.Data(resp.StatusCode, "application/json", respBody)
}

func (h *ProxyHandler) ProxyRecents(c *gin.Context) {
	req, err := http.NewRequest("GET", h.monolithURL+"/bonus/recents", nil)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create request"})
		return
	}

	resp, err := h.httpClient.Do(req)
	if err != nil {
		c.JSON(http.StatusBadGateway, gin.H{"error": "Failed to connect to monolith"})
		return
	}
	defer resp.Body.Close()

	respBody, _ := ioutil.ReadAll(resp.Body)
	c.Data(resp.StatusCode, "application/json", respBody)
}

func (h *ProxyHandler) ProxyGet(c *gin.Context) {
	id := c.Param("id")
	req, err := http.NewRequest("GET", h.monolithURL+"/bonus/"+id, nil)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create request"})
		return
	}

	resp, err := h.httpClient.Do(req)
	if err != nil {
		c.JSON(http.StatusBadGateway, gin.H{"error": "Failed to connect to monolith"})
		return
	}
	defer resp.Body.Close()

	respBody, _ := ioutil.ReadAll(resp.Body)
	c.Data(resp.StatusCode, "application/json", respBody)
}
