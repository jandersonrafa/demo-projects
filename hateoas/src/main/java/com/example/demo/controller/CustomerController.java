package com.example.demo.controller;

import com.example.demo.dto.Customer;
import com.example.demo.dto.Order;
import com.example.demo.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.CollectionModel;
import org.springframework.hateoas.Link;
import org.springframework.hateoas.LinkRelation;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.List;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@RestController
@RequestMapping(value = "/customers")
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    @GetMapping("/{customerId}")
    public Customer getCustomerById(@PathVariable String customerId) {
        Customer customer = customerService.getCustomer(customerId);

        customer.add(linkTo(methodOn(CustomerController.class).getCustomerById(customerId)).withSelfRel());
        customer.add(linkTo(methodOn(CustomerController.class).getOrdersForCustomer(customerId)).withRel("orders"));
        return customer;
    }

    @GetMapping(value = "/{customerId}/orders", produces = { "application/hal+json" })
    public CollectionModel<Order> getOrdersForCustomer(@PathVariable final String customerId) {
        List<Order> orders = customerService.getOrders(customerId);

        for (final Order order : orders) {
            order.add(linkTo(methodOn(CustomerController.class).getOrderById(customerId, order.getOrderId())).withSelfRel());
        }

        Link link = linkTo(methodOn(CustomerController.class).getOrdersForCustomer(customerId)).withSelfRel();
        return CollectionModel.of(orders, link);
    }

    @GetMapping(value = "/{customerId}/orders/{orderId}", produces = { "application/hal+json" })
    public Order getOrderById(@PathVariable final String customerId, @PathVariable final String orderId) {
        return customerService.getOrders(customerId).stream().filter(o-> o.getOrderId().equals(orderId)).findFirst().get();
    }

}