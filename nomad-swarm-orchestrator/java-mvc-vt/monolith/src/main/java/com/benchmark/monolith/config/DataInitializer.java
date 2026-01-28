package com.benchmark.monolith.config;

import com.benchmark.monolith.domain.Client;
import com.benchmark.monolith.repository.ClientRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class DataInitializer implements CommandLineRunner {

    private final ClientRepository clientRepository;

    @Override
    public void run(String... args) throws Exception {
        if (clientRepository.count() == 0) {
            Client client1 = new Client();
            client1.setId("client_1");
            client1.setName("Test Client 1");
            client1.setActive(true);
            
            Client client2 = new Client();
            client2.setId("client_2");
            client2.setName("Test Client 2");
            client2.setActive(true);
            
            clientRepository.save(client1);
            clientRepository.save(client2);
            
            System.out.println("Sample clients created successfully");
        }
    }
}
