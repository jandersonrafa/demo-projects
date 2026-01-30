package com.benchmark.gateway;

import org.springframework.http.HttpStatus;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.DefaultUriBuilderFactory;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.client5.http.impl.io.PoolingHttpClientConnectionManager;
import org.apache.hc.client5.http.classic.HttpClient;

@RestController
@RequestMapping("/bonus")
public class GatewayController {
    private final RestTemplate restTemplate;

    public GatewayController() {
        String monolithUrl = System.getenv().getOrDefault("MONOLITH_URL", "http://localhost:3003");

        PoolingHttpClientConnectionManager connectionManager = new PoolingHttpClientConnectionManager();
        connectionManager.setMaxTotal(500);
        connectionManager.setDefaultMaxPerRoute(500);

        HttpClient httpClient = HttpClients.custom()
                .setConnectionManager(connectionManager)
                .build();

        HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory(httpClient);

        this.restTemplate = new RestTemplate(factory);
        this.restTemplate.setUriTemplateHandler(new DefaultUriBuilderFactory(monolithUrl));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Object createBonus(@RequestBody Object body) {
        return restTemplate.postForObject("/bonus", body, Object.class);
    }

    @GetMapping("/{id}")
    public Object getBonus(@PathVariable String id) {
        return restTemplate.getForObject("/bonus/" + id, Object.class);
    }
}
