package com.keycloak.springkeycloak.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;

/**
 * HelloController
 */
@RestController
@RequestMapping("/api")
public class HelloController {

    @GetMapping("/hello")
    public String getMethodName() {
        return "hello";
    }

    // @PreAuthorize("hasAuthority('SCOPE_profile2')")
    @GetMapping("/hello2")
    public String getMethodName2(Principal principal) {
        OAuth2AuthenticationToken token = (OAuth2AuthenticationToken) principal;
        token.getPrincipal().getName();
        return "hello2";
    }
    
    
}