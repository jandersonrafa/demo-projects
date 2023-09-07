package com.example.demo.dto;

import lombok.*;

import java.io.Serializable;

@Data
public class Student implements Serializable {
    private Long id;
    private String name;
    private String document;
    private Long courseId;
}
