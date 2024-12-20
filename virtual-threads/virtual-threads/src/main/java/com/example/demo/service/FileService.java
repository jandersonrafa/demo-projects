package com.example.demo.service;

import com.example.demo.model.Employee;
import org.springframework.stereotype.Service;

import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.LocalDate;

@Service
public class FileService {
    public Employee process(Employee employee) {
        // Realizar operações adicionais de I/O em loop para aumentar o estresse
        String fileName = "output" + employee.getFirstName() + ".txt";
        try {
            Files.deleteIfExists(Paths.get(fileName));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        try (FileWriter fileWriter = new FileWriter(fileName)) {
            for (int i = 0; i < 100; i++) {
                fileWriter.write("Iteration: " + employee);
            }
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException(e);

        }
        return employee;
    }

}
