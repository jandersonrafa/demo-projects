package com.example.demo.controller;

import org.springframework.web.bind.annotation.*;

import java.util.Optional;
@RestController
@RequestMapping("/v1/temperature")
public class TemperatureController {

    @GetMapping("/convert-to-fahrenheit/{celsius}")
    public double getFahrenheit(@PathVariable String celsius) {
        try {
            Thread.sleep(1000);
        }
        catch (Exception e ){

        }
        double fahrenheit = 0;
        if(Optional.ofNullable(celsius).isPresent()){
            fahrenheit = (9 * Double.parseDouble(celsius) + (32 * 5))/5;
        }
        return fahrenheit;
    }

    @GetMapping("/convert-to-celsius")
    public double getCelsius (@RequestParam String fahrenheit) {
        try {
            Thread.sleep(1000);
        }
        catch (Exception e ){

        }
        double  celsius = 0 ;
        if(Optional.ofNullable(fahrenheit).isPresent()){
            celsius =(( 5 *(Double.parseDouble(fahrenheit) - 32.0)) / 9.0);
        }
        return celsius;
    }
}