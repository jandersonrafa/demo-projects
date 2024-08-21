package com.example.demo.scheduler;

import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class AsyncTask {

    @Async
    public void testSched() {
        System.out.println("teste");
    }
}
