package com.benchmark.monolith.domain;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

@Table("clients")
public record Client(
    @Id String id,
    String name,
    Boolean active
) {}
