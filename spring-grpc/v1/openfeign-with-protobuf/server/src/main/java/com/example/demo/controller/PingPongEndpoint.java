package com.example.demo.controller;

import com.example.demo.server.grpcserver.PongResponse;
import com.example.demo.service.PingPongServiceImpl;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/pingpong")
public class PingPongEndpoint {

    private final PingPongServiceImpl pingPongService;

    @GetMapping(value = "/ping")
//    @GetMapping(value = "/ping" , produces = "application/x-protobuf")
    public PongResponse ping() {
        return pingPongService.ping();
    }
}
