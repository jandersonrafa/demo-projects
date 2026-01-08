package com.benchmark.monolith.domain;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;
import org.springframework.data.relational.core.mapping.Column;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Table("bonus")
public record Bonus(
                @Id Long id,
                BigDecimal amount,
                String description,
                @Column("client_id") String clientId,
                @Column("expiration_date") LocalDateTime expirationDate,
                @Column("created_at") LocalDateTime createdAt) {
}
