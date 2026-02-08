package com.benchmark.monolith.service;

import com.benchmark.monolith.entity.Bonus;
import com.benchmark.monolith.repository.BonusRepository;
import java.math.BigDecimal;
import java.time.LocalDateTime;
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
        BigDecimal amount = bonus.getAmount();
        if (amount != null && amount.compareTo(new BigDecimal("100")) > 0) {
            bonus.setAmount(amount.multiply(new BigDecimal("1.1")));
        }

        bonus.setDescription("JAVAQUARKUS - " + bonus.getDescription());
        bonus.setCreatedAt(LocalDateTime.now());
        bonus.setExpirationDate(LocalDateTime.now().plusDays(30));

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
