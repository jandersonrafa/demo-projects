package com.example.demo.service;

import com.example.demo.client.PongClient;
import com.example.demo.server.grpcserver.PongResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OpenFeignClientService {
    private final RestTemplate restTemplate;

//    public String ping() {
//        PongResponse helloResponse = pongClient.pingPong();
//        return helloResponse.getPong() + helloResponse.getDescricao() + helloResponse.getListTeste().stream().collect(Collectors.joining(",")) + helloResponse.getListProduct().stream().map(PongResponse.Product::getName).collect(Collectors.joining(","));
//    }
    public String ping() {
        ResponseEntity<PongResponse> pongResponse = restTemplate.getForEntity("http://localhost:8081/api/pingpong/ping", PongResponse.class);
        PongResponse helloResponse = pongResponse.getBody();
        return helloResponse.getPong() + helloResponse.getDescricao() + helloResponse.getListTesteList().stream().collect(Collectors.joining(",")) + helloResponse.getListProductList().stream().map(PongResponse.Product::getName).collect(Collectors.joining(","));
    }
//    public String ping() {
//        ResponseEntity<PongResponse> pongResponse = restTemplate.getForEntity("http://localhost:8081/api/pingpong/ping", PongResponse.class);
//        PongResponse helloResponse = pongResponse.getBody();
//        return helloResponse.getPong() + helloResponse.getDescricao() + helloResponse.getListTesteList().stream().collect(Collectors.joining(",")) + helloResponse.getListProductList().stream().map(PongResponse.Product::getName).collect(Collectors.joining(","));
//    }
}