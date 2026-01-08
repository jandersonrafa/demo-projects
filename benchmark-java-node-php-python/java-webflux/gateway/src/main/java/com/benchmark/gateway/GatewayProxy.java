package com.benchmark.gateway;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.server.RouterFunction;
import org.springframework.web.reactive.function.server.ServerResponse;
import static org.springframework.web.reactive.function.server.RequestPredicates.*;
import static org.springframework.web.reactive.function.server.RouterFunctions.route;

@Configuration
public class GatewayProxy {
    private final String monolithUrl = System.getenv().getOrDefault("MONOLITH_URL", "http://localhost:3002");

    @Bean
    public WebClient webClient(WebClient.Builder builder) {
        return builder.baseUrl(monolithUrl).build();
    }

    @Bean
    public RouterFunction<ServerResponse> proxyRoutes(WebClient webClient) {
        return route(POST("/bonus"), request -> 
            request.bodyToMono(Object.class)
                .flatMap(body -> webClient.post().uri("/bonus").bodyValue(body).retrieve().toEntity(Object.class))
                .flatMap(response -> ServerResponse.status(response.getStatusCode()).bodyValue(response.getBody()))
        ).andRoute(GET("/bonus/{id}"), request ->
            webClient.get().uri("/bonus/" + request.pathVariable("id")).retrieve().toEntity(Object.class)
                .flatMap(response -> ServerResponse.status(response.getStatusCode()).bodyValue(response.getBody()))
        );
    }
}
