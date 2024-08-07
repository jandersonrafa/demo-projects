package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PesquisaService {

    @Autowired
    private PesquisaGradeProdutoAdaptee gradeProdutoAdaptee;

    public List<String> buscaFiltros() {
        return gradeProdutoAdaptee.buscaEtrataFiltros();
    }
}
