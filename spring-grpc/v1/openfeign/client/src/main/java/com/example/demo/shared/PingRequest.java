package com.example.demo.shared;

import lombok.*;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class PingRequest {
    private String ping;

}
