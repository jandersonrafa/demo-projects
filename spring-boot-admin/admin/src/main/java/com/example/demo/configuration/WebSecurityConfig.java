package com.example.demo.configuration;

import de.codecentric.boot.admin.server.config.AdminServerProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.cors.CorsConfiguration;

import java.util.Arrays;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig {

    private final AdminServerProperties adminServer;

    public WebSecurityConfig(AdminServerProperties adminServer) {
        this.adminServer = adminServer;
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        SavedRequestAwareAuthenticationSuccessHandler successHandler = new SavedRequestAwareAuthenticationSuccessHandler();
        successHandler.setTargetUrlParameter("redirectTo");
        successHandler.setDefaultTargetUrl(this.adminServer.getContextPath() + "/");
        http.authorizeHttpRequests(req -> req.requestMatchers(this.adminServer.getContextPath() + "/assets/**")
                        .permitAll()
                        .requestMatchers("/webjars/**", "/css/**", "/images/**")
                        .permitAll()

                        .requestMatchers(this.adminServer.getContextPath() + "/login", this.adminServer.getContextPath() + "/logout")
                        .permitAll()
                        .anyRequest()
                        .authenticated())
                .formLogin(formLogin -> formLogin.loginPage(this.adminServer.getContextPath() + "/login")
                        .successHandler(successHandler).permitAll())
                .logout((formLogout) -> formLogout.clearAuthentication(true).invalidateHttpSession(true).deleteCookies("JSESSIONID").permitAll().logoutSuccessUrl("/"))
                .httpBasic(Customizer.withDefaults())

                .csrf(csrf -> csrf.csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
                        .ignoringRequestMatchers(
                                new AntPathRequestMatcher(this.adminServer.getContextPath() + "/instances", HttpMethod.POST.toString()),
                                new AntPathRequestMatcher(this.adminServer.getContextPath() + "/instances/**", HttpMethod.DELETE.toString()),
                                new AntPathRequestMatcher(this.adminServer.getContextPath() + "/instances/**", HttpMethod.POST.toString()),
                                new AntPathRequestMatcher(this.adminServer.getContextPath() + "/logout", HttpMethod.GET.toString()),
                                new AntPathRequestMatcher(this.adminServer.getContextPath() + "/actuator/**")))
                .cors(cors -> cors.configurationSource(request -> {
                    CorsConfiguration configuration = new CorsConfiguration();
                    configuration.setAllowedOrigins(Arrays.asList("*"));
                    configuration.setAllowedMethods(Arrays.asList("*"));
                    configuration.setAllowedHeaders(Arrays.asList("*"));
                    return configuration;
                }))

        ;
        return http.build();
    }
}