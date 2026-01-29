package com.benchmark.monolith.domain;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "clients")
@Data
public class Client {
    @Id
    private String id;
    private String name;
    private Boolean active;
}
