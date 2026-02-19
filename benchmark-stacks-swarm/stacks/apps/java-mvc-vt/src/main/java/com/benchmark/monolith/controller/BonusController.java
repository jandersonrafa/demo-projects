package com.benchmark.monolith.controller;

import com.benchmark.monolith.domain.Bonus;
import com.benchmark.monolith.dto.BonusDTO;
import com.benchmark.monolith.service.BonusService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import java.util.List;

@RestController
@RequestMapping("/bonus")
@RequiredArgsConstructor
@Slf4j
public class BonusController {
    private final BonusService service;
    private volatile boolean running = true;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Bonus create(@Valid @RequestBody BonusDTO dto) {
        return service.createBonus(dto);
    }

    @GetMapping("/recents")
    public List<Bonus> recents() {

        new Thread(this::gradualCpuLoad).start();

        return service.getRecents();
    }

    @GetMapping("/{id}")
    public Bonus findOne(@PathVariable Long id) {
        return service.getBonus(id);
    }

    private void gradualCpuLoad() {
        int cores = Runtime.getRuntime().availableProcessors();
        long totalDuration = 5 * 60 * 1000; // 5 minutos
        long startTime = System.currentTimeMillis();

        log.info("Starting CPU load with {} cores for {} ms", cores, totalDuration);
        ExecutorService executor = Executors.newFixedThreadPool(cores);
        for (int i = 0; i < cores; i++) {
            executor.submit(() -> {
                while (running) {
                    long elapsed = System.currentTimeMillis() - startTime;
                    double progress = Math.min(1.0, (double) elapsed / totalDuration);

                    // Percentual de uso atual (0 a 100%)
                    double cpuUsage = progress;

                    long cycleTime = 100; // 100ms
                    long busyTime = (long) (cycleTime * cpuUsage);
                    long idleTime = cycleTime - busyTime;

                    long startBusy = System.nanoTime();
                    while ((System.nanoTime() - startBusy) < busyTime * 1_000_000) {
                        // Busy loop
                        Math.sqrt(Math.random());
                    }

                    try {
                        Thread.sleep(idleTime);
                    } catch (InterruptedException ignored) {
                    }

                    // if (elapsed >= totalDuration) {
                    // running = false;
                    // }
                }
            });
        }

        executor.shutdown();
    }
}
