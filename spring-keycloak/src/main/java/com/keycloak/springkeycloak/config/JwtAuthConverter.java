package com.keycloak.springkeycloak.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.convert.converter.Converter;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.oidc.OidcIdToken;
import org.springframework.security.oauth2.core.oidc.OidcUserInfo;
import org.springframework.security.oauth2.core.oidc.user.DefaultOidcUser;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtClaimNames;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;
import org.springframework.stereotype.Component;
import org.springframework.util.Assert;

import java.util.Collection;
import java.util.HashMap;

@Slf4j
@Component
@RequiredArgsConstructor
/**
 * Classe utilizada para processar token vindo no cabecalho bearer token
 * e converter realm_access do keycloak para authorities spring
 */
public class JwtAuthConverter implements Converter<Jwt, OAuth2AuthenticationToken> {

    private final JwtAuthorityConverter jwtAuthorityConverter;

    private Converter<Jwt, Collection<GrantedAuthority>> jwtGrantedAuthoritiesConverter = new JwtGrantedAuthoritiesConverter();

    private String principalClaimName = JwtClaimNames.SUB;

    @Override
    public final OAuth2AuthenticationToken convert(Jwt jwt) {
        this.jwtGrantedAuthoritiesConverter = jwtAuthorityConverter;
        Collection<GrantedAuthority> authorities = this.jwtGrantedAuthoritiesConverter.convert(jwt);
        OAuth2User oAuth2User = new DefaultOAuth2User(authorities, jwt.getClaims(), this.principalClaimName);
        OAuth2AuthenticationToken jwtAuthenticationToken = new OAuth2AuthenticationToken(oAuth2User, authorities, principalClaimName);
        return jwtAuthenticationToken;
    }

}