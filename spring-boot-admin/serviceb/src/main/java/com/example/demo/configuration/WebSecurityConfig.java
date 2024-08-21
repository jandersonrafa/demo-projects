package com.example.demo.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter;
import org.springframework.security.web.csrf.CookieCsrfTokenRepository;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.cors.CorsConfiguration;

import java.util.Arrays;
import java.util.UUID;

import static org.springframework.security.config.Customizer.withDefaults;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig {

//
//    @Bean
//    public InMemoryUserDetailsManager userDetailsService(PasswordEncoder passwordEncoder) {
//        UserDetails user = User.withUsername("serviceblogin")
//                .password(passwordEncoder.encode("serviceblogin"))
//                .roles("ADMIN")
//                .build();
//        return new InMemoryUserDetailsManager(user);
//    }
//
//    @Bean
//    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
////        http.httpBasic(Customizer.withDefaults())
////                .sessionManagement(httpSecuritySessionManagementConfigurer -> httpSecuritySessionManagementConfigurer.sessionCreationPolicy(SessionCreationPolicy.ALWAYS))
////                .authorizeRequests((authorizeRequests) -> authorizeRequests.requestMatchers("/")
////                        .hasRole("ADMIN")
////                        .anyRequest()
////                        .authenticated()).cors(cors -> cors.configurationSource(request -> {
////                    CorsConfiguration configuration = new CorsConfiguration();
////                    configuration.setAllowedOrigins(Arrays.asList("*"));
////                    configuration.setAllowedMethods(Arrays.asList("*"));
////                    configuration.setAllowedHeaders(Arrays.asList("*"));
////                    return configuration;
////                }));;
////        return http.build();
//
//        SavedRequestAwareAuthenticationSuccessHandler successHandler = new SavedRequestAwareAuthenticationSuccessHandler();
//        successHandler.setTargetUrlParameter("redirectTo");
//        successHandler.setDefaultTargetUrl("/");
//
//        http.authorizeHttpRequests(req ->
//                        req.requestMatchers("/assets/**")
//                                .permitAll()
//                                .requestMatchers("/login", "/logout")
//                                .permitAll()
//                                .anyRequest()
//                                .authenticated())
//                .formLogin(formLogin -> formLogin.loginPage("/login")
//                        .successHandler(successHandler))
//                .logout((logout) -> logout.logoutUrl("/logout"))
//                .httpBasic(Customizer.withDefaults())
//                .csrf(csrf -> csrf.csrfTokenRepository(CookieCsrfTokenRepository.withHttpOnlyFalse())
//                        .ignoringRequestMatchers(
//                                new AntPathRequestMatcher("/actuator/**")))
//                .rememberMe(rememberMe -> rememberMe.key(UUID.randomUUID()
//                                .toString())
//                        .tokenValiditySeconds(1209600))
//                .cors(cors -> cors.configurationSource(request -> {
//                    CorsConfiguration configuration = new CorsConfiguration();
//                    configuration.setAllowedOrigins(Arrays.asList("*"));
//                    configuration.setAllowedMethods(Arrays.asList("*"));
//                    configuration.setAllowedHeaders(Arrays.asList("*"));
//                    return configuration;
//                }));
//        return http.build();
//    }
//
//    @Bean
//    public PasswordEncoder passwordEncoder() {
//        return new BCryptPasswordEncoder();
//    }

//    @Bean
//    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
//
//        http.
//                authorizeHttpRequests(req -> req.anyRequest()
//                        .authenticated())
//                .sessionManagement(httpSecuritySessionManagementConfigurer -> httpSecuritySessionManagementConfigurer.sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED))
//                .csrf().disable()
//                .httpBasic(Customizer.withDefaults()).cors(cors -> cors.configurationSource(request -> {
//                    CorsConfiguration configuration = new CorsConfiguration();
//                    configuration.setAllowedOrigins(Arrays.asList("*"));
//                    configuration.setAllowedMethods(Arrays.asList("*"));
//                    configuration.setAllowedHeaders(Arrays.asList("*"));
//                    return configuration;
//                }));
//        return http.build();
//    }

    @Bean
    public InMemoryUserDetailsManager userDetailsService(PasswordEncoder passwordEncoder) {
        UserDetails user = User.withUsername("serviceblogin")
                .password(passwordEncoder.encode("serviceblogin"))
                .roles("ADMIN")
                .build();
        return new InMemoryUserDetailsManager(user);
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.httpBasic(withDefaults())
                .sessionManagement(httpSecuritySessionManagementConfigurer -> httpSecuritySessionManagementConfigurer.sessionCreationPolicy(SessionCreationPolicy.ALWAYS))
                .authorizeRequests((authorizeRequests) -> authorizeRequests.requestMatchers("/")
                        .hasRole("ADMIN")
                        .anyRequest()
                        .authenticated())
                .csrf().disable()
                .httpBasic(Customizer.withDefaults()).cors(cors -> cors.configurationSource(request -> {
                    CorsConfiguration configuration = new CorsConfiguration();
                    configuration.setAllowedOrigins(Arrays.asList("*"));
                    configuration.setAllowedMethods(Arrays.asList("*"));
                    configuration.setAllowedHeaders(Arrays.asList("*"));
                    return configuration;
                }));
        ;
        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}