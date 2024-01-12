package com.example.demo.controller;


import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;

@Slf4j
@Configuration
public class WebclientConfig {
    @Bean
    protected WebClient.Builder webClientBuilder() {
        return WebClient.builder();
    }
}
