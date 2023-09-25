package com.example.demo.service;

import com.example.demo.dto.PessoaDto;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class MinhaSegundaServiceHelloService {
    public void hello() {
//        for (int i = 0; i < 100; i++) {
//            PessoaDto pessoaDto = new PessoaDto();
//            pessoaDto.setIdadePessoa(10L);
//            pessoaDto.setNomePessoa("teste");
//            listPessoa.add(pessoaDto);
//        }
//        Thread.sleep(10000);

        List<PessoaDto> items = new ArrayList<>(1);
        try {
            while (true){
                items.add(new PessoaDto());
            }
        } catch (OutOfMemoryError e){
            System.out.println(e.getMessage());
        }
        assert items.size() > 0;
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            System.out.println(e.getMessage());
        }

    }
}
