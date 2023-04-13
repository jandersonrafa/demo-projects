package com.example.demo.service;

import com.example.demo.client.PongClient;
import com.example.demo.shared.PingRequest;
import com.example.demo.shared.PongResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OpenFeignClientService {
    private final PongClient pongClient;
    public String ping() {
        PongResponse helloResponse = pongClient.pingPong();
        return helloResponse.getPong() + helloResponse.getDescricao() + helloResponse.getListTeste().stream().collect(Collectors.joining(",")) + helloResponse.getListProduct().stream().map(PongResponse.Product::getName).collect(Collectors.joining(","));
    }
}