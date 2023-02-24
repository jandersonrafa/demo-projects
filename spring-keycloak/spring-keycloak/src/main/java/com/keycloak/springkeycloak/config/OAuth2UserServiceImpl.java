//package com.keycloak.springkeycloak.config;
//
//import org.springframework.security.core.GrantedAuthority;
//import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
//import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
//import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
//import org.springframework.security.oauth2.core.oidc.user.DefaultOidcUser;
//import org.springframework.security.oauth2.core.user.OAuth2User;
//import org.springframework.security.oauth2.jwt.Jwt;
//import org.springframework.stereotype.Service;
//
//import java.util.Collection;
//import java.util.Map;
//
//@Service
//public class OAuth2UserServiceImpl implements OAuth2UserService {
//    @Override
//    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
//        return new DefaultOidcUser(null, null);
////        return new OAuth2User() {
////            @Override
////            public Map<String, Object> getAttributes() {
////                return null;
////            }
////
////            @Override
////            public Collection<? extends GrantedAuthority> getAuthorities() {
////                return null;
////            }
////
////            @Override
////            public String getName() {
////                return "teste";
////            }
////        };
//    }
//}
