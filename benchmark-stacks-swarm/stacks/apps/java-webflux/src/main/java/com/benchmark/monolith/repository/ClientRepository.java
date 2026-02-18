package com.benchmark.monolith.repository;

import com.benchmark.monolith.domain.Client;
import org.springframework.data.repository.reactive.ReactiveCrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ClientRepository extends ReactiveCrudRepository<Client, String> {
}
