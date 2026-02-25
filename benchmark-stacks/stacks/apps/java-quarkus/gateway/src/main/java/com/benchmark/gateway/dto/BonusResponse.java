package com.benchmark.gateway.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class BonusResponse {
    private Long id;
    private String clientId;
    private BigDecimal amount;
    private String description;
    private LocalDateTime createdAt;

    public BonusResponse() {
    }

    public BonusResponse(Long id, String clientId, BigDecimal amount, String description, LocalDateTime createdAt) {
        this.id = id;
        this.clientId = clientId;
        this.amount = amount;
        this.description = description;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getClientId() {
        return clientId;
    }

    public void setClientId(String clientId) {
        this.clientId = clientId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
