package com.example.demo.service;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PesquisaGradeProdutoAdaptee extends AbstractGradeProduto {
    @Override
    protected List<String> buscaFiltros() {
        return null;
    }
}
