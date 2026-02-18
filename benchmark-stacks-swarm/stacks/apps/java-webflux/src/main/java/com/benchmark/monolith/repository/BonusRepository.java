package com.benchmark.monolith.repository;

import com.benchmark.monolith.domain.Bonus;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;
import reactor.core.publisher.Flux;

@Repository
public interface BonusRepository extends ReactiveCrudRepository<Bonus, Long> {
    Flux<Bonus> findTop100ByOrderByIdAsc();
}
