package com.spendwise.config;

import com.spendwise.service.CustomUserDetailsService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.*;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

/**
 * LOCATION : src/main/java/com/spendwise/config/SecurityConfig.java
 * CONNECTS TO:
 *   - CustomUserDetailsService.java (Step 4) → loads user from DB
 *   - application.properties        (Step 3) → session timeout config
 *   - AuthController.java           (Step 4) → login/logout routes
 *   - All HTML templates            (Step 6+) → protected by these rules
 *   - users table                   (Step 2) → where credentials are stored
 */
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final CustomUserDetailsService customUserDetailsService;

    // ────────────────────────────────────────────────────────────
    // PASSWORD ENCODER — BCrypt with strength 10
    // Used by: AuthService (encode on register, match on login)
    // ────────────────────────────────────────────────────────────
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(10);
    }

    // ────────────────────────────────────────────────────────────
    // AUTHENTICATION PROVIDER
    // Wires CustomUserDetailsService + BCrypt together
    // ────────────────────────────────────────────────────────────
    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
        provider.setUserDetailsService(customUserDetailsService);
        provider.setPasswordEncoder(passwordEncoder());
        return provider;
    }

    // ────────────────────────────────────────────────────────────
    // AUTHENTICATION MANAGER — Used by AuthController for login
    // ────────────────────────────────────────────────────────────
    @Bean
    public AuthenticationManager authenticationManager(
            AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    // ────────────────────────────────────────────────────────────
    // SECURITY FILTER CHAIN — Core security rules
    // ────────────────────────────────────────────────────────────
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            // ── URL Access Rules ──────────────────────────────
            .authorizeHttpRequests(auth -> auth
                // Public routes — no login needed
                .requestMatchers(
                    "/",
                    "/login",
                    "/api/auth/login",
                    "/api/auth/register",
                    "/css/**",
                    "/js/**",
                    "/images/**",
                    "/favicon.ico",
                    "/error"
                ).permitAll()
                // All other routes require authentication
                .anyRequest().authenticated()
            )

            // ── Login Configuration ───────────────────────────
            .formLogin(form -> form
                .loginPage("/login")                        // Our custom login page
                .loginProcessingUrl("/api/auth/login")      // Spring processes POST here
                .defaultSuccessUrl("/dashboard", true)      // Redirect after login
                .failureUrl("/login?error=true")            // Redirect on failure
                .usernameParameter("email")                 // Match our form field name
                .passwordParameter("password")
                .permitAll()
            )

            // ── Logout Configuration ──────────────────────────
            .logout(logout -> logout
                .logoutRequestMatcher(new AntPathRequestMatcher("/logout", "POST"))
                .logoutSuccessUrl("/login?logout=true")     // Redirect after logout
                .invalidateHttpSession(true)                // Clear session data
                .deleteCookies("SPENDWISE_SESSION")         // Delete session cookie
                .clearAuthentication(true)
                .permitAll()
            )

            // ── Remember Me ───────────────────────────────────
            .rememberMe(remember -> remember
                .key("spendwise-remember-me-secret-key")
                .tokenValiditySeconds(7 * 24 * 60 * 60)    // 7 days
                .userDetailsService(customUserDetailsService)
                .rememberMeParameter("rememberMe")
            )

            // ── Session Management ────────────────────────────
            .sessionManagement(session -> session
                .maximumSessions(1)                         // One session per user
                .expiredUrl("/login?expired=true")
            )

            // ── CSRF Protection ───────────────────────────────
            // Enabled by default — Thymeleaf adds token to forms automatically
            .authenticationProvider(authenticationProvider());

        return http.build();
    }
}
