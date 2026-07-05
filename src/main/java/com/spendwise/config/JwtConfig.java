package com.spendwise.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * JWT Configuration Properties
 * Values are loaded from application.properties (app.jwt.*)
 * To be used in Phase 5 (Security Implementation)
 */
@Getter
@Setter
@Configuration
@ConfigurationProperties(prefix = "app.jwt")
public class JwtConfig {

    /** JWT secret key (min 256 bits) */
    private String secret;

    /** Token expiry in milliseconds (default: 24 hours) */
    private long expiration = 86400000L;

    /** Refresh token expiry (default: 7 days) */
    private long refreshExpiration = 604800000L;

    /** Token prefix in Authorization header */
    private String tokenPrefix = "Bearer";

    /** HTTP header name */
    private String header = "Authorization";
}
