package com.example.demo.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/load")
@Slf4j
public class LoadTestController {


    @GetMapping
    public void doSomething() throws InterruptedException {
        log.info("hey, I'm doing something");
        Thread.sleep(3000);
    }
}
