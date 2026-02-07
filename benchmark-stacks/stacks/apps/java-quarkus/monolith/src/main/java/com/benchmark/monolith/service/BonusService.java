package com.benchmark.monolith.service;

import com.benchmark.monolith.entity.Bonus;
import com.benchmark.monolith.repository.BonusRepository;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import io.quarkus.panache.common.Sort;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

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

    public List<Bonus> getRecents() {
        // Fetch top 100 bonuses ordered by ID ascending
        List<Bonus> bonuses = bonusRepository.findAll(Sort.ascending("id")).range(0, 99).list();

        // Then sort in memory by createdAt descending to stress memory
        return bonuses.stream()
                .sorted(Comparator.comparing(Bonus::getCreatedAt).reversed())
                .limit(10)
                .collect(Collectors.toList());
    }
}
