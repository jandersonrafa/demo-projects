package com.benchmark.monolith.controller;

import com.benchmark.monolith.domain.Bonus;
import com.benchmark.monolith.dto.BonusDTO;
import com.benchmark.monolith.service.BonusService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/bonus")
@RequiredArgsConstructor
public class BonusController {
    private final BonusService service;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Bonus create(@Valid @RequestBody BonusDTO dto) {
        return service.createBonus(dto);
    }

    @GetMapping("/{id}")
    public Bonus findOne(@PathVariable Long id) {
        return service.getBonus(id);
    }
}
