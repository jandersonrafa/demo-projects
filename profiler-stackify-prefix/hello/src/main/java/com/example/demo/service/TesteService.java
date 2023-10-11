package com.example.demo.service;

import org.springframework.stereotype.Service;

@Service
public class TesteService {
    public void testeChamada() {
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        System.out.println("teste");
    }
}
