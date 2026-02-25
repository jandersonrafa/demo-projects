package domain

import "time"

type Client struct {
	ID     string `gorm:"primaryKey"`
	Name   string
	Active bool
}

type Bonus struct {
	ID             uint      `gorm:"primaryKey;autoIncrement" json:"id"`
	Amount         float64   `json:"amount"`
	Description    string    `json:"description"`
	ClientID       string    `gorm:"column:client_id" json:"clientId"`
	ExpirationDate time.Time `gorm:"column:expiration_date" json:"expirationDate"`
	CreatedAt      time.Time `gorm:"column:created_at;default:CURRENT_TIMESTAMP" json:"createdAt"`
}
