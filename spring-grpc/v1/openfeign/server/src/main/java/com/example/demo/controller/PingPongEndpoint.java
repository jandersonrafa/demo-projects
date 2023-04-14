package com.example.demo.controller;

import com.example.demo.service.PingPongServiceImpl;
import com.example.demo.shared.PingRequest;
import com.example.demo.shared.PongResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/pingpong")
public class PingPongEndpoint {

    private final PingPongServiceImpl pingPongService;

    @GetMapping("/ping")
    public PongResponse ping() {
        return pingPongService.ping(null);
    }
}
