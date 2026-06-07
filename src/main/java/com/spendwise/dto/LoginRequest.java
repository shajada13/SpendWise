package com.spendwise.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * LOCATION: src/main/java/com/spendwise/dto/LoginRequest.java
 * CONNECTS TO:
 *   - AuthController.java → receives this from login form
 *   - AuthService.java    → validates and processes
 */
@Data
public class LoginRequest {

    @NotBlank(message = "Email is required")
    @Email(message = "Please enter a valid email address")
    private String email;

    @NotBlank(message = "Password is required")
    @Size(min = 6, message = "Password must be at least 6 characters")
    private String password;

    private boolean rememberMe;
}
