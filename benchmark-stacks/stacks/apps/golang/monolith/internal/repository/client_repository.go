package repository

import (
	"monolith/internal/domain"
	"gorm.io/gorm"
)

type ClientRepository interface {
	FindByID(id string) (*domain.Client, error)
}

type clientRepository struct {
	db *gorm.DB
}

func NewClientRepository(db *gorm.DB) ClientRepository {
	return &clientRepository{db}
}

func (r *clientRepository) FindByID(id string) (*domain.Client, error) {
	var client domain.Client
	if err := r.db.First(&client, "id = ?", id).Error; err != nil {
		return nil, err
	}
	return &client, nil
}
