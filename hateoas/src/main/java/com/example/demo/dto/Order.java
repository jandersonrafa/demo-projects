package com.example.demo.dto;

import lombok.Builder;
import lombok.Data;
import org.springframework.hateoas.RepresentationModel;


@Data
@Builder
public class Order extends RepresentationModel<Order> {
    private String orderId;
    private double price;
    private int quantity;

    // standard getters and setters
}
