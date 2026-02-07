package com.benchmark.monolith.controller;

import com.benchmark.monolith.domain.Bonus;
import com.benchmark.monolith.dto.BonusDTO;
import com.benchmark.monolith.service.BonusService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping("/bonus")
@RequiredArgsConstructor
public class BonusController {
    private final BonusService service;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Mono<Bonus> create(@Valid @RequestBody BonusDTO dto) {
        return service.createBonus(dto);
    }

    @GetMapping("/recents")
    public Flux<Bonus> getRecents() {
        return service.getRecents();
    }

    @GetMapping("/{id}")
    public Mono<Bonus> findOne(@PathVariable Long id) {
        return service.getBonus(id);
    }
}
