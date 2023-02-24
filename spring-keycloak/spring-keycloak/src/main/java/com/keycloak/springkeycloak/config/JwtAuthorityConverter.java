package com.keycloak.springkeycloak.config;

import org.springframework.core.convert.converter.Converter;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.core.oidc.OidcUserInfo;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtClaimNames;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;
import org.springframework.stereotype.Component;

import java.awt.*;
import java.util.Collection;
import java.util.Collections;
import java.util.Map;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Component
public class JwtAuthorityConverter implements Converter<Jwt, Collection<GrantedAuthority>> {

    @Override
    public Collection<GrantedAuthority> convert(Jwt jwt) {
        return convert(jwt.getClaimAsMap("realm_access"));
    }
    public Collection<GrantedAuthority> convert(OidcUserInfo oidcUserInfo) {
        return convert(oidcUserInfo.getClaimAsMap("realm_access"));
    }
    public Collection<GrantedAuthority> convert( Map<String, Object> realmAccess) {
        if (realmAccess != null) {
            @SuppressWarnings("unchecked")
            List<String> roles = (List<String>) realmAccess.get("roles");
            if (roles != null) {
                return roles.stream()
                        .map(rn -> new SimpleGrantedAuthority("ROLE_" + rn))
                        .collect(Collectors.toList());
            }
        }

        return Collections.emptyList();
    }

}