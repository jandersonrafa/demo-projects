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
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class BonusService {
    private final BonusRepository repository;
    private final ClientRepository clientRepository;

    public Bonus createBonus(BonusDTO dto) {
        Client client = clientRepository.findById(dto.getClientId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Client not found"));

        if (!client.getActive()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Client is inactive");
        }

        BigDecimal finalAmount = dto.getAmount();
        if (finalAmount.compareTo(new BigDecimal("100")) > 0) {
            finalAmount = finalAmount.multiply(new BigDecimal("1.1"));
        }

        Bonus bonus = new Bonus();
        bonus.setAmount(finalAmount);
        bonus.setDescription("JAVAMVC - " + dto.getDescription());
        bonus.setClientId(dto.getClientId());
        bonus.setCreatedAt(LocalDateTime.now());
        bonus.setExpirationDate(LocalDateTime.now().plusDays(30));

        return repository.save(bonus);
    }

    public Bonus getBonus(Long id) {
        return repository.findById(id).orElse(null);
    }
}
