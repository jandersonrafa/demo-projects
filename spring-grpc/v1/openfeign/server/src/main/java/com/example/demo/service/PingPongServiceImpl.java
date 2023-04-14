package com.example.demo.service;

import com.example.demo.shared.PingRequest;
import com.example.demo.shared.PongResponse;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
public class PingPongServiceImpl {

    public PongResponse ping(PingRequest pingRequest) {
        return PongResponse.builder()
                .pong("pong")
                .descricao("teste")
                .listTeste(getListTeste())
                .listProduct(getListProduct())
                .build();
    }

    private static List<PongResponse.Product> getListProduct() {
        List<PongResponse.Product> list = new ArrayList<>();

        for (int i = 0; i < 10; i++) {
            PongResponse.Product product1 = PongResponse
                    .Product.builder()
                    .name("teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1")
                    .name2("teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1")
                    .name3("teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1")
                    .name4("teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1")
                    .name5("teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1")
                    .name6("teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1")
                    .name7("teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1")
                    .price(2.)
                    .quantity(2)
                    .build();
            list.add(product1);
        }
        return list;
    }

    private static List<String> getListTeste() {
        List<String> list = new ArrayList<>();

        for (int i = 0; i < 10; i++) {
            list.add("teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1");
        }
        return list;
    }
}
