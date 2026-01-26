package service

import (
	"errors"
	"monolith/internal/domain"
	"monolith/internal/dto"
	"monolith/internal/repository"
	"time"

	"gorm.io/gorm"
)

type BonusService interface {
	CreateBonus(dto dto.BonusDTO) (*domain.Bonus, error)
	GetBonus(id string) (*domain.Bonus, error)
}

type bonusService struct {
	bonusRepo  repository.BonusRepository
	clientRepo repository.ClientRepository
}

func NewBonusService(bonusRepo repository.BonusRepository, clientRepo repository.ClientRepository) BonusService {
	return &bonusService{bonusRepo, clientRepo}
}

func (s *bonusService) CreateBonus(dto dto.BonusDTO) (*domain.Bonus, error) {
	client, err := s.clientRepo.FindByID(dto.ClientID)
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, errors.New("client not found")
		}
		return nil, err
	}

	if !client.Active {
		return nil, errors.New("client is inactive")
	}

	finalAmount := dto.Amount
	if finalAmount > 100 {
		finalAmount *= 1.1
	}

	bonus := &domain.Bonus{
		Amount:         finalAmount,
		Description:    "GOLANG - " + dto.Description,
		ClientID:       dto.ClientID,
		CreatedAt:      time.Now(),
		ExpirationDate: time.Now().AddDate(0, 0, 30),
	}

	if err := s.bonusRepo.Create(bonus); err != nil {
		return nil, err
	}

	return bonus, nil
}

func (s *bonusService) GetBonus(id string) (*domain.Bonus, error) {
	bonus, err := s.bonusRepo.FindByID(id)
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, nil // Return nil correctly for "not found" to represent null
		}
		return nil, err
	}
	return bonus, nil
}
