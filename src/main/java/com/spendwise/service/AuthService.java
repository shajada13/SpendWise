package com.spendwise.service;

import com.spendwise.dto.RegisterRequest;
import com.spendwise.model.User;
import com.spendwise.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

/**
 * LOCATION : src/main/java/com/spendwise/service/AuthService.java
 * CONNECTS TO:
 *   - UserRepository.java  (Step 4) → DB operations on users table
 *   - User.java            (Step 4) → User entity / model
 *   - RegisterRequest.java (Step 4) → Registration form data
 *   - SecurityConfig.java  (Step 4) → BCryptPasswordEncoder bean
 *   - AuthController.java  (Step 4) → Calls these methods
 *   - users table          (Step 2) → Where data is stored
 */
@Service
@RequiredArgsConstructor
public class AuthService {

    // ── Injected by Spring (Step 4 components) ──────────────────
    private final UserRepository   userRepository;   // → users table
    private final PasswordEncoder  passwordEncoder;  // → BCrypt (SecurityConfig)

    // ────────────────────────────────────────────────────────────
    // REGISTER — Creates a new user account
    // Called by: AuthController POST /api/auth/register
    // ────────────────────────────────────────────────────────────
    @Transactional
    public User registerUser(RegisterRequest request) {

        // 1. Check email is not already taken
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email is already registered. Please login.");
        }

        // 2. Check passwords match
        if (!request.getPassword().equals(request.getConfirmPassword())) {
            throw new RuntimeException("Passwords do not match.");
        }

        // 3. Build User entity — maps to users table (Step 2 schema.sql)
        User user = User.builder()
                .fullName(request.getFullName())
                .email(request.getEmail().toLowerCase().trim())
                .password(passwordEncoder.encode(request.getPassword())) // BCrypt hash
                .currency("BDT")
                .theme(User.Theme.light)
                .isActive(true)
                .build();

        // 4. Save to MySQL users table via JPA
        return userRepository.save(user);
    }

    // ────────────────────────────────────────────────────────────
    // FIND USER BY EMAIL — Used during login + Spring Security
    // Called by: AuthController, CustomUserDetailsService
    // ────────────────────────────────────────────────────────────
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email.toLowerCase().trim());
    }

    // ────────────────────────────────────────────────────────────
    // VALIDATE PASSWORD — Used during login
    // Compares raw password with BCrypt stored hash
    // ────────────────────────────────────────────────────────────
    public boolean validatePassword(String rawPassword, String encodedPassword) {
        return passwordEncoder.matches(rawPassword, encodedPassword);
    }

    // ────────────────────────────────────────────────────────────
    // CHANGE PASSWORD — Called from Profile page (Step 13)
    // ────────────────────────────────────────────────────────────
    @Transactional
    public void changePassword(Long userId, String oldPassword, String newPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found."));

        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new RuntimeException("Current password is incorrect.");
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }

    // ────────────────────────────────────────────────────────────
    // UPDATE PROFILE — Called from Profile page (Step 13)
    // ────────────────────────────────────────────────────────────
    @Transactional
    public User updateProfile(Long userId, String fullName, String email) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found."));

        // Check email not taken by another user
        if (!user.getEmail().equals(email) && userRepository.existsByEmail(email)) {
            throw new RuntimeException("Email already in use by another account.");
        }

        user.setFullName(fullName);
        user.setEmail(email.toLowerCase().trim());
        return userRepository.save(user);
    }

    // ────────────────────────────────────────────────────────────
    // GET USER BY ID — Used across all pages to get logged-in user
    // ────────────────────────────────────────────────────────────
    public User getUserById(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found."));
    }
}
