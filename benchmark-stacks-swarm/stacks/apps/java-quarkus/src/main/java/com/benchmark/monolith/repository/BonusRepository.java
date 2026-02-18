package com.benchmark.monolith.repository;

import com.benchmark.monolith.entity.Bonus;
import io.quarkus.hibernate.orm.panache.PanacheRepository;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class BonusRepository implements PanacheRepository<Bonus> {
}
