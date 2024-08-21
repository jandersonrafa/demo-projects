package com.example.demo.controller;

import org.springframework.cache.annotation.Cacheable;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/hello")
public class HelloController {



    @Cacheable(cacheNames = "testecache")
    @GetMapping("")
    public String hello() {
        return "hello";
    }



}