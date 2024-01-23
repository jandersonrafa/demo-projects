package com.example.demo.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.client.ServiceInstance;
import org.springframework.cloud.client.discovery.DiscoveryClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import javax.naming.ServiceUnavailableException;
import java.net.URI;
import java.util.List;
import java.util.Optional;
import java.util.Random;

@RestController
@RequestMapping("/hello")
@Slf4j
public class HelloController {


    @Autowired
    private DiscoveryClient discoveryClient;

    private final RestTemplate restTemplate = new RestTemplate();


    public Optional<URI> serviceUrl() {
        List<ServiceInstance> instances = discoveryClient.getInstances("test-server-consul");
        return instances
                .stream()
                .skip(instances.isEmpty() ? 0 : new Random().nextInt(instances.size()))
                .findFirst()
                .map(si -> si.getUri());
    }

    @GetMapping("")
    public String hello() throws ServiceUnavailableException {
            URI service = serviceUrl()
                    .map(s -> s.resolve("/hello/server"))
                    .orElseThrow(ServiceUnavailableException::new);
        return restTemplate.getForEntity(service, String.class)
                .getBody();


    }

//    @GetMapping("/ping")
//    public String ping() {
//        return "pong";
//    }


}