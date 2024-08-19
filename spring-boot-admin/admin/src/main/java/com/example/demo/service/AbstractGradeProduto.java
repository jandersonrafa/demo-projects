package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

public abstract class AbstractGradeProduto {

    @Autowired
    private TesteService testeService;
    protected abstract List<String> buscaFiltros() ;



    public List<String> buscaEtrataFiltros() {
        testeService.testeService();
        return buscaFiltros();
    }
}
