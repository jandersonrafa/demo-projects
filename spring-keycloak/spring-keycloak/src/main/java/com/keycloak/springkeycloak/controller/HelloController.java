package com.keycloak.springkeycloak.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * HelloController
 */
@RestController
@RequestMapping("/api")
public class HelloController {

    @GetMapping("/hello")
    public String getMethodName() {
        return "teste s";
    }
    @GetMapping("/hello2")
    public String getMethodName2() {
        return "teste s";
    }
    
    
}