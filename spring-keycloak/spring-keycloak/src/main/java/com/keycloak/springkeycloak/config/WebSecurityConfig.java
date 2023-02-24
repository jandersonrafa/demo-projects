package com.keycloak.springkeycloak.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.core.convert.converter.Converter;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.mapping.GrantedAuthoritiesMapper;
import org.springframework.security.oauth2.client.oidc.userinfo.OidcUserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.oidc.user.DefaultOidcUser;
import org.springframework.security.oauth2.core.oidc.user.OidcUser;
import org.springframework.security.oauth2.core.oidc.user.OidcUserAuthority;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2UserAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.web.SecurityFilterChain;

import java.util.Collection;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

@RequiredArgsConstructor
@Configuration
@EnableWebSecurity
public class WebSecurityConfig {

    public static final String ADMIN = "admin";
    public static final String USER = "user";
    private final JwtAuthorityConverter jwtAuthorityConverter;

    private final KeycloakLogoutHandler keycloakLogoutHandler;
    private final JwtAuthConverter jwtAuthConverter;

    @Bean
    @Order(Ordered.HIGHEST_PRECEDENCE)
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http.authorizeHttpRequests()
                .requestMatchers(HttpMethod.GET, "/api/hello2", "/test/anonymous/**").permitAll()
                .requestMatchers(HttpMethod.GET, "/api/admin", "/test/admin/**").hasRole(ADMIN)
                .requestMatchers(HttpMethod.GET, "/api/hello").hasAnyRole(USER)
                .anyRequest().authenticated();

        JwtAuthenticationConverter converter = new JwtAuthenticationConverter();
        converter.setJwtGrantedAuthoritiesConverter(jwtAuthorityConverter);
        http.oauth2Login().userInfoEndpoint().userAuthoritiesMapper(userAuthoritiesMapper());
//                .oidcUserService(new OAuth2UserService<OidcUserRequest, OidcUser>() {
//            @Override
//            public OidcUser loadUser(OidcUserRequest userRequest) throws OAuth2AuthenticationException {
//                return new DefaultOidcUser(null, userRequest.getIdToken());
//            }
//        });
//        http.oauth2Login().userInfoEndpoint().userAuthoritiesMapper(userAuthoritiesMapper()).oidcUserService(oAuth2UserServiceImpl);
                http.logout()
                .addLogoutHandler(keycloakLogoutHandler)
                .logoutSuccessUrl("/")
                .and()
                .oauth2ResourceServer(oauth2 -> oauth2
                        .jwt(jwt -> jwt
                                .jwtAuthenticationConverter(jwtAuthConverter)
                        )
                );
//                .and()
//                .oauth2ResourceServer(oauth2 -> oauth2
//                        .jwt(jwt -> jwt
//                                .jwtAuthenticationConverter(converter)
//                        )
//                );

//                .jwt()
//                .jwtAuthenticationConverter(jwtAuthConverter);
//        http.oauth2Login();
//        http.oauth2Login()
//                .and()
//                .logout()
//                .addLogoutHandler(keycloakLogoutHandler)
//                .logoutSuccessUrl("/");

//        http.sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS);

        return http.build();
    }

//    @Bean
    GrantedAuthoritiesMapper userAuthoritiesMapper() {
        return (authorities) -> {
            Set<GrantedAuthority> mappedAuthorities = new HashSet<>();

            authorities.forEach(authority -> {
                if (authority instanceof OidcUserAuthority oidcAuth) {
                    mappedAuthorities.addAll(jwtAuthorityConverter.convert(oidcAuth.getUserInfo()));
                } else if (authority instanceof OAuth2UserAuthority oauth2Auth) {
                    mappedAuthorities.addAll(jwtAuthorityConverter.convert(oauth2Auth.getAttributes()));

                }
            });

            return mappedAuthorities;
        };
    }




//    @Bean
//    Converter<Jwt, Collection<GrantedAuthority>> userAuthoritiesMapper() {
//        return new Converter<Jwt, Collection<GrantedAuthority>>() {
//            @Override
//            public Collection<GrantedAuthority> convert(Jwt source) {
//                return null;
//            }
//        };
//    }
//    @Bean
//    GrantedAuthoritiesMapper userAuthoritiesMapper(Converter<Jwt, Collection<? extends GrantedAuthority>> authoritiesConverter) {
//        return (authorities) -> {
//            Set<GrantedAuthority> mappedAuthorities = new HashSet<>();
//
//            authorities.forEach(authority -> {
//                if (authority instanceof OidcUserAuthority oidcAuth) {
//                    mappedAuthorities.addAll(authoritiesConverter.convert(oidcAuth.getIdToken().getClaims()));
//
//                } else if (authority instanceof OAuth2UserAuthority oauth2Auth) {
//                    mappedAuthorities.addAll(authoritiesConverter.convert(oauth2Auth.getAttributes()));
//
//                }
//            });
//
//            return mappedAuthorities;
//        };
//    }

//    @Bean
//    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
//
//        JwtAuthenticationConverter converter = new JwtAuthenticationConverter();
//        converter.setJwtGrantedAuthoritiesConverter(jwtAuthorityConverter);
//
//        http.oauth2ResourceServer()
//                .jwt()
//                .jwtAuthenticationConverter(converter);
//        http.oauth2Login()
//                .and()
//                .logout()
//                .addLogoutHandler(keycloakLogoutHandler)
//                .logoutSuccessUrl("/");
//        http.authorizeHttpRequests()
//                .requestMatchers("/api/hello2").permitAll()
//                .requestMatchers("/api/hello").hasRole(USER).anyRequest().authenticated();
//
//        return http.build();
//    }



}