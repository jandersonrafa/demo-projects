package com.benchmark.monolith.service;

import com.benchmark.monolith.entity.Bonus;
import com.benchmark.monolith.repository.BonusRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;

@ApplicationScoped
public class BonusService {

    @Inject
    BonusRepository bonusRepository;

    @Transactional
    public Bonus createBonus(Bonus bonus) {
        bonusRepository.persist(bonus);
        return bonus;
    }

    public Bonus getBonusById(Long id) {
        return bonusRepository.findById(id);
    }
}
