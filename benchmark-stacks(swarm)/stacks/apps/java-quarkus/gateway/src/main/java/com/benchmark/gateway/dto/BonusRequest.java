package com.benchmark.gateway.dto;

import java.math.BigDecimal;

public class BonusRequest {
    private String clientId;
    private BigDecimal amount;
    private String description;

    public BonusRequest() {
    }

    public BonusRequest(String clientId, BigDecimal amount, String description) {
        this.clientId = clientId;
        this.amount = amount;
        this.description = description;
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
}
