package com.example.demo.controller;

import com.example.demo.dto.Student;
import com.example.demo.service.StudentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Random;

@RestController
@RequestMapping("/students")
@RequiredArgsConstructor
public class StudentController {

    private final StudentService studentService;

    @GetMapping("")
    public ResponseEntity<Student>  createWithGetExample() {
        Student student = new Student();
        student.setId(new Random().nextLong());
        student.setDocument(new Random().nextInt() + "tste");
        student.setCourseId(new Random().nextLong());
        student.setDocument(new Random().nextLong() + "test");
        studentService.sendMessage(student);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @PostMapping
    public ResponseEntity<Student> createStudent(@RequestBody Student student) {
        studentService.sendMessage(student);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

}