package com.example.demo.service;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoriaGradeProdutoAdaptee extends AbstractGradeProduto implements GradeProdutoAdapter {
    @Override
    public List<String> buscaFiltros() {
        return null;
    }
}
