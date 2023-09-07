package com.example.demo.service;

import com.example.demo.dto.Student;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import java.io.Serializable;

@Service
@RequiredArgsConstructor
@Log4j2
public class StudentListener {

    @KafkaListener(topics = "student-topic", groupId = "student-group", containerFactory = "jsonContainerFactory")
    public void consumeMessage(Student student) {
        log.info("Reading Student {}", student);
    }
}
