package com.example.demo.service;


import com.example.demo.dto.Customer;
import com.example.demo.dto.Order;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

@Service
public class CustomerService {
    public Customer getCustomer(String customerId) {
        return Customer
                .builder()
                .customerName("Rafael")
                .customerId("1")
                .companyName("Compania")
                .build();
    }

    public List<Order> getOrders(String customerId) {
        Order build = Order.builder().price(1).quantity(2).orderId("1").build();
        Order build2 = Order.builder().price(1).quantity(2).orderId("2").build();
        List<Order> orders = Arrays.asList(build, build2);
        return orders;
    }
}
