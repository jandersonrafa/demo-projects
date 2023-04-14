package com.example.demo.controller;

import com.example.demo.service.OpenFeignClientService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/pingpong")
public class PingPongEndpoint {

    private final OpenFeignClientService grpcClientService;

    @GetMapping("/ping")
    public String ping() {
        return grpcClientService.ping();
    }
}
