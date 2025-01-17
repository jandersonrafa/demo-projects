package com.example.demo.controller;

import com.example.demo.dto.Pessoa;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/pessoa")
public class DumpController {

    List<Pessoa> pessoas = new ArrayList<>();

    @GetMapping("")
    public String hello() {
        for (int i = 0; i < 1000000000; i++) {
            Pessoa pessoa = new Pessoa("teste", "teste");
            pessoas.add(pessoa);
        }

        return "hello";
    }

}