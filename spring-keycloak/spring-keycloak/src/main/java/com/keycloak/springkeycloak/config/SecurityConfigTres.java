// package com.keycloak.springkeycloak.config;
//
// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;
// import org.springframework.core.convert.converter.Converter;
// import org.springframework.security.authentication.AbstractAuthenticationToken;
// import org.springframework.security.config.annotation.web.builders.HttpSecurity;
// import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
// import org.springframework.security.core.session.SessionRegistryImpl;
// import org.springframework.security.oauth2.jwt.Jwt;
// import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
// import org.springframework.security.web.SecurityFilterChain;
// import org.springframework.security.web.authentication.session.RegisterSessionAuthenticationStrategy;
// import org.springframework.security.web.authentication.session.SessionAuthenticationStrategy;
//
// @Configuration
// @EnableWebSecurity
// class SecurityConfigTres {
//
//     String jwkSetUri = "http://localhost:8080/auth/realms/wstutorial/protocol/openid-connect/certs";
//
//     private final KeycloakLogoutHandler keycloakLogoutHandler;
//
//     SecurityConfigTres(KeycloakLogoutHandler keycloakLogoutHandler) {
//         this.keycloakLogoutHandler = keycloakLogoutHandler;
//     }
//
//
//     @Bean
//     protected SessionAuthenticationStrategy sessionAuthenticationStrategy() {
//         return new RegisterSessionAuthenticationStrategy(new SessionRegistryImpl());
//     }
//
//     @Bean
//     public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
//         http.authorizeHttpRequests()
//             .requestMatchers("/api/hello")
//             // .hasAuthority("SCOPE_user")
//            //  .hasAuthority("SCOPE_profile")
//             .hasRole("ROLE_user")
//             .anyRequest()
//             .permitAll();
//             // .hasRole("user")
//             // .anyRequest()
//             // .permitAll()
//             ;
//         http.oauth2Login()
//             .and()
//             .logout()
//             .addLogoutHandler(keycloakLogoutHandler)
//             .logoutSuccessUrl("/");
//         http.oauth2ResourceServer().jwt().jwtAuthenticationConverter(jwtAuthenticationConverter());
//
////        http.oauth2ResourceServer(oauth2ResourceServer ->
////                 oauth2ResourceServer
////                         .jwt(jwt ->
////                                 jwt.jwtAuthenticationConverter(jwtAuthenticationConverter()))
////         );
//
//
//         // http.authorizeHttpRequests()
//         //     .requestMatchers("/api/hello")
//         //     .hasAuthority("user")
//         //     // .hasRole("user")
//         //     .anyRequest()
//         //     .permitAll();
//         //     // .hasRole("user")
//         //     // .anyRequest()
//         //     // .permitAll()
//         //     ;
//         // http.oauth2Login()
//         //     .and()
//         //     .logout()
//         //     .addLogoutHandler(keycloakLogoutHandler)
//         //     .logoutSuccessUrl("/");
//         // http.oauth2ResourceServer(OAuth2ResourceServerConfigurer::jwt);
//         return http.build();
//     }
//
//     private Converter<Jwt, ? extends AbstractAuthenticationToken> jwtAuthenticationConverter() {
//         JwtAuthenticationConverter jwtConverter = new JwtAuthenticationConverter();
//         jwtConverter.setJwtGrantedAuthoritiesConverter(new KeycloakRealmRoleConverter());
//         return jwtConverter;
//     }
//
////     @Bean
////     JwtDecoder jwtDecoder() {
////         return NimbusJwtDecoder.withJwkSetUri(this.jwkSetUri).build();
////     }
//
// }