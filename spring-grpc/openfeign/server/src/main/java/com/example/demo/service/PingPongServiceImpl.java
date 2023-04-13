package com.example.demo.service;

import com.example.demo.shared.PingRequest;
import com.example.demo.shared.PongResponse;
import org.springframework.stereotype.Service;

import java.util.Arrays;

@Service
public class PingPongServiceImpl {

    public PongResponse ping(PingRequest pingRequest) {
        return PongResponse.builder()
                .pong("pong")
                .descricao("teste")
                .listTeste(Arrays.asList("teste1", "teste2", "teste3"))
                .listProduct(Arrays.asList(PongResponse.Product.builder().name("product1").price(2.).quantity(2).build(), PongResponse.Product.builder().name("product2").price(2.).quantity(2).build()))
                .build();
    }
}
