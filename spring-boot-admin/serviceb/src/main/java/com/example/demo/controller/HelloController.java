package com.example.demo.controller;

import jakarta.annotation.security.RolesAllowed;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.context.config.annotation.RefreshScope;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/hello")
@RefreshScope

public class HelloController {


    @Value("${variable.test}")
    private String myProperty;

    @RolesAllowed("ADMIN")
    @GetMapping("")
    public String hello(HttpServletRequest request) {
        return "hello"  + myProperty +  request.getSession().getId();
    }

    @DeleteMapping("")
    public String helloDe() {
        return "hellodeleted";
    }

}