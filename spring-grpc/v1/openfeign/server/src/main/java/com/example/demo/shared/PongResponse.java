package com.example.demo.shared;

import lombok.*;

import java.util.List;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class PongResponse {

    private String pong;
    private String descricao;
    private List<String> listTeste;
    private List<Product> listProduct;

    @Builder
    @AllArgsConstructor
    @NoArgsConstructor
    @Getter
    @Setter
    public static class Product {
        private String pong;
        private String name;
        private String name2;
        private String name3;
        private String name4;
        private String name5;
        private String name6;
        private String name7;
        private Integer quantity;
        private Double price;
        private Boolean status;
    }
}
