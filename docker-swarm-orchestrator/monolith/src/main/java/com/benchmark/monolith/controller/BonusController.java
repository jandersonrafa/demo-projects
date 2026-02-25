package com.benchmark.monolith.controller;

import com.benchmark.monolith.domain.Bonus;
import com.benchmark.monolith.dto.BonusDTO;
import com.benchmark.monolith.service.BonusService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/bonus")
@RequiredArgsConstructor
public class BonusController {
    private static final Logger logger = LoggerFactory.getLogger(BonusController.class);
    private final BonusService service;
    private final String serverPort = System.getenv("SERVER_PORT");

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Bonus create(@Valid @RequestBody BonusDTO dto) {
        logger.info("Request handled by Monolith instance on port: {}", serverPort);
        return service.createBonus(dto);
    }

    @GetMapping("/{id}")
    public Bonus findOne(@PathVariable Long id) {
        logger.info("Request handled by Monolith instance on port: {}", serverPort);
        return service.getBonus(id);
    }
}
