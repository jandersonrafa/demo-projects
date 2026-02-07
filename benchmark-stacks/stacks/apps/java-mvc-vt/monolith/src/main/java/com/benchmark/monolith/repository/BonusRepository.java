package com.benchmark.monolith.repository;

import com.benchmark.monolith.domain.Bonus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BonusRepository extends JpaRepository<Bonus, Long> {
    List<Bonus> findTop100ByOrderByIdAsc();
}
