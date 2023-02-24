package com.keycloak.springkeycloak.config;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.mapping.GrantedAuthoritiesMapper;
import org.springframework.security.oauth2.core.oidc.user.OidcUserAuthority;
import org.springframework.security.oauth2.core.user.OAuth2UserAuthority;
import org.springframework.stereotype.Component;

import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

@Component
@RequiredArgsConstructor
public class GrantedAuthoritiesMapperImpl implements GrantedAuthoritiesMapper {

    private final JwtAuthorityConverter jwtAuthorityConverter;

    @Override
    public Collection<? extends GrantedAuthority> mapAuthorities(Collection<? extends GrantedAuthority> authorities) {
        Set<GrantedAuthority> mappedAuthorities = new HashSet<>();

        authorities.forEach(authority -> {
            if (authority instanceof OidcUserAuthority oidcAuth) {
                mappedAuthorities.addAll(jwtAuthorityConverter.convert(oidcAuth.getUserInfo()));
            } else if (authority instanceof OAuth2UserAuthority oauth2Auth) {
                mappedAuthorities.addAll(jwtAuthorityConverter.convert(oauth2Auth.getAttributes()));

            }
        });

        return mappedAuthorities;
    }

    ;
}
