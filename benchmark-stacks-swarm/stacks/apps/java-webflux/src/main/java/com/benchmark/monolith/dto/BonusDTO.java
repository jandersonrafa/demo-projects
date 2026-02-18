package com.benchmark.monolith.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;

public record BonusDTO(
    @NotNull(message = "Amount is required")
    @Min(value = 0, message = "Amount must be positive")
    BigDecimal amount,

    @NotBlank(message = "Description is required")
    String description,

    @NotBlank(message = "ClientId is required")
    String clientId
) {}
