package com.benchmark.monolith.service;

import com.benchmark.monolith.domain.Bonus;
import com.benchmark.monolith.domain.Client;
import com.benchmark.monolith.dto.BonusDTO;
import com.benchmark.monolith.repository.BonusRepository;
import com.benchmark.monolith.repository.ClientRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;
import reactor.core.publisher.Mono;
import java.math.BigDecimal;
import java.time.LocalDateTime;

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
                    LocalDateTime.now()
                );
                return repository.save(toSave);
            });
    }

    public Mono<Bonus> getBonus(Long id) {
        return repository.findById(id);
    }
}
