package com.example.demo.scheduler;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class SchedulerTask {

    @Scheduled(fixedDelay = 10000L)
    public void testSched() {
        System.out.println("teste");
    }
}
