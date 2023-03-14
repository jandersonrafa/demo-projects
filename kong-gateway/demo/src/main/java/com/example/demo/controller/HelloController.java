package com.example.demo.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class HelloController {
    @GetMapping("api/hello")
    @ResponseBody
    public String teste() {
        try {
            Thread.sleep(1000);
        }
        catch (Exception e ){

        }
        
        return "teste";
    }
    
}
