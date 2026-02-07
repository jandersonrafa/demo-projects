package handler

import (
	"monolith/internal/dto"
	"monolith/internal/service"
	"net/http"

	"github.com/gin-gonic/gin"
)

type BonusHandler struct {
	service service.BonusService
}

func NewBonusHandler(s service.BonusService) *BonusHandler {
	return &BonusHandler{s}
}

func (h *BonusHandler) Create(c *gin.Context) {
	var dto dto.BonusDTO
	if err := c.ShouldBindJSON(&dto); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	bonus, err := h.service.CreateBonus(dto)
	if err != nil {
		if err.Error() == "client not found" {
			c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
			return
		}
		if err.Error() == "client is inactive" {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		return
	}

	c.JSON(http.StatusCreated, bonus)
}

func (h *BonusHandler) GetRecents(c *gin.Context) {
	bonuses, err := h.service.GetRecents()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		return
	}

	c.JSON(http.StatusOK, bonuses)
}

func (h *BonusHandler) GetOne(c *gin.Context) {
	id := c.Param("id")
	bonus, err := h.service.GetBonus(id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		return
	}

	c.JSON(http.StatusOK, bonus)
}
