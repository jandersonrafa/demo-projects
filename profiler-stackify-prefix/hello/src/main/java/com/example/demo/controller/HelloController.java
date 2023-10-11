package com.example.demo.controller;

import com.example.demo.dto.PessoaDto;
import com.example.demo.service.MinhaSegundaServiceHelloService;
import com.example.demo.service.MinhaServiceHelloService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/hello")
public class HelloController {

    public static List<PessoaDto> listPessoa = new ArrayList<>();

    @Autowired
    private MinhaServiceHelloService minhaServiceHelloService;
    @Autowired
    private MinhaSegundaServiceHelloService minhaSegundaServiceHelloService;

    @GetMapping("")
    public String hello() throws InterruptedException {
        minhaServiceHelloService.hello();

        return "hello";
    }
    @GetMapping("/v2")
    public String hello2() throws InterruptedException {
        minhaSegundaServiceHelloService.hello();

        return "hello";
    }

}