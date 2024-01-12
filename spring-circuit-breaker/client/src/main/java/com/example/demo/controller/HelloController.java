package com.example.demo.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.circuitbreaker.CircuitBreaker;
import org.springframework.cloud.client.circuitbreaker.CircuitBreakerFactory;
import org.springframework.http.HttpMethod;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.Arrays;
import java.util.List;

@RestController
@RequestMapping("/hello")
@Slf4j
public class HelloController {

    @Autowired
    private WebClient.Builder webClientBuilder;

    @Autowired
    private CircuitBreakerFactory circuitBreakerFactory;

    @GetMapping("")
    public List<String> hello() {
        CircuitBreaker circuitBreaker = circuitBreakerFactory.create("circuitbreakerhello");
        return circuitBreaker.run(() -> callServer(), throwable -> getDefaultResponseHello());
    }

    private List<String> getDefaultResponseHello() {
        log.info("Defaul response");
        return Arrays.asList("response default");
    }

    private  List<String> callServer() {
        log.info("Call server");
        String response = webClientBuilder.build().get()
                .uri("http://localhost:2000/hello")
                .retrieve()
                .bodyToMono(String.class)
                .block();

        return Arrays.asList(response);
    }

}