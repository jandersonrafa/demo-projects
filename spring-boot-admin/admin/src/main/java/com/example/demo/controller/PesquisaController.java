package com.example.demo.controller;

import com.example.demo.service.PesquisaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/pesquisa")
public class PesquisaController {


    @Autowired
    private PesquisaService pesquisaService;

    @GetMapping
    public ResponseEntity buscaFiltros() {
        pesquisaService.buscaFiltros();
        return ResponseEntity.ok().build();
    }
}
