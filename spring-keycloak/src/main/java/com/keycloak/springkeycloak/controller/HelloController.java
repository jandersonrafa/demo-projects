package com.keycloak.springkeycloak.controller;

import jakarta.servlet.http.HttpServletRequest;
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

    @GetMapping("/public")
    public String publicMethod() {
        return "Endpoint público";
    }

    @GetMapping("/private/user")
    public String privateMethodUser(Principal principal, HttpServletRequest request) {
        OAuth2AuthenticationToken token = (OAuth2AuthenticationToken) principal;
        String name = token.getPrincipal().getName();
        return "Endpoint privado - User : "  + name + " com permissao user";
    }
    @GetMapping("/private/admin")
    public String privateMethodAdmin(Principal principal) {
        OAuth2AuthenticationToken token = (OAuth2AuthenticationToken) principal;
        String name = token.getPrincipal().getName();
        return "Endpoint privado - User : "  + name + " com permissao admin";
    }

}