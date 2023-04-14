package com.example.demo.service;

import com.example.demo.server.grpcserver.PongResponse;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class PingPongServiceImpl {

    public PongResponse ping() {
        List<String> listTeste = getListTeste();
        List<PongResponse.Product> listProduct = getListProduct();
        PongResponse response = PongResponse.newBuilder()
                .setPong("pong")
                .setDescricao("teste")
                .addAllListTeste(listTeste)
                .addAllListProduct(listProduct)
                .build();
        return response;
    }

    private static List<PongResponse.Product> getListProduct() {
        List<PongResponse.Product> list = new ArrayList<>();

        for (int i = 0; i < 10; i++) {
            PongResponse.Product product1 = PongResponse
                    .Product.newBuilder()
                    .setName("teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1")
                    .setName2("teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1")
                    .setName3("teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1")
                    .setName4("teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1")
                    .setName5("teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1")
                    .setName6("teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1")
                    .setName7("teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1teste1")
                    .setPrice(2)
                    .setQuantity(2)
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
