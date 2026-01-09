package com.benchmark.gateway;

import org.springframework.http.HttpStatus;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.DefaultUriBuilderFactory;

@RestController
@RequestMapping("/bonus")
public class GatewayController {
    private final RestTemplate restTemplate;

    public GatewayController() {
        String monolithUrl = System.getenv().getOrDefault("MONOLITH_URL", "http://localhost:3003");
        this.restTemplate = new RestTemplate();
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
