package repository

import (
	"monolith/internal/domain"
	"gorm.io/gorm"
)

type BonusRepository interface {
	Create(bonus *domain.Bonus) error
	FindByID(id string) (*domain.Bonus, error)
}

type bonusRepository struct {
	db *gorm.DB
}

func NewBonusRepository(db *gorm.DB) BonusRepository {
	return &bonusRepository{db}
}

func (r *bonusRepository) Create(bonus *domain.Bonus) error {
	return r.db.Create(bonus).Error
}

func (r *bonusRepository) FindByID(id string) (*domain.Bonus, error) {
	var bonus domain.Bonus
	if err := r.db.First(&bonus, id).Error; err != nil {
		return nil, err
	}
	return &bonus, nil
}
