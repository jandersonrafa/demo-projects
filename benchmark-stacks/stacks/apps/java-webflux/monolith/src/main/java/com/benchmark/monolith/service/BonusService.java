package com.benchmark.monolith.service;

import com.benchmark.monolith.domain.Bonus;
import com.benchmark.monolith.dto.BonusDTO;
import com.benchmark.monolith.repository.BonusRepository;
import com.benchmark.monolith.repository.ClientRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class BonusService {
    private final BonusRepository repository;
    private final ClientRepository clientRepository;

    public Mono<Bonus> createBonus(BonusDTO dto) {
        return clientRepository.findById(dto.clientId())
                .switchIfEmpty(Mono.error(new ResponseStatusException(HttpStatus.NOT_FOUND, "Client not found")))
                .flatMap(client -> {
                    if (!client.active()) {
                        return Mono.error(new ResponseStatusException(HttpStatus.BAD_REQUEST, "Client is inactive"));
                    }

                    BigDecimal finalAmount = dto.amount();
                    if (finalAmount.compareTo(new BigDecimal("100")) > 0) {
                        finalAmount = finalAmount.multiply(new BigDecimal("1.1"));
                    }

                    LocalDateTime expirationDate = LocalDateTime.now().plusDays(30);

                    Bonus toSave = new Bonus(
                            null,
                            finalAmount,
                            "JAVAWEBFLUX - " + dto.description(),
                            dto.clientId(),
                            expirationDate,
                            LocalDateTime.now());
                    return repository.save(toSave);
                });
    }

    public Mono<Bonus> getBonus(Long id) {
        return repository.findById(id);
    }

    public Flux<Bonus> getRecents() {
        // Fetch top 100 bonuses ordered by ID ascending
        return repository.findAll()
                .sort(Comparator.comparing(Bonus::id))
                .take(100)
                .collectList()
                .flatMapMany(list -> {
                    // Then sort in memory by createdAt descending to stress memory
                    list.sort(Comparator.comparing(Bonus::createdAt).reversed());
                    List<Bonus> limited = list.stream()
                            .limit(10)
                            .collect(Collectors.toList());
                    return Flux.fromIterable(limited);
                });
    }
}
