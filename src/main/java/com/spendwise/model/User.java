package com.spendwise.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

/**
 * LOCATION : src/main/java/com/spendwise/model/User.java
 * CONNECTS TO:
 *   - database/schema.sql      (Step 2) → maps to users table
 *   - UserRepository.java      (Step 4) → JPA reads/writes this entity
 *   - AuthService.java         (Step 4) → creates and updates User objects
 *   - CustomUserDetailsService (Step 4) → loads this for Spring Security
 *   - AuthController.java      (Step 4) → returns User data in responses
 *
 * TABLE: users (defined in schema.sql Step 2)
 * COLUMNS: id, full_name, email, password, avatar_url,
 *          currency, theme, is_active, created_at, updated_at
 */
@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    // ── PRIMARY KEY ──────────────────────────────────────────────
    // Maps to: id BIGINT AUTO_INCREMENT (schema.sql)
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // ── USER INFO ────────────────────────────────────────────────
    // Maps to: full_name VARCHAR(100) NOT NULL
    @Column(name = "full_name", nullable = false, length = 100)
    private String fullName;

    // Maps to: email VARCHAR(150) NOT NULL UNIQUE
    @Column(name = "email", nullable = false, unique = true, length = 150)
    private String email;

    // Maps to: password VARCHAR(255) NOT NULL (BCrypt hash)
    @Column(name = "password", nullable = false, length = 255)
    private String password;

    // Maps to: avatar_url VARCHAR(255)
    @Column(name = "avatar_url", length = 255)
    private String avatarUrl;

    // ── PREFERENCES ──────────────────────────────────────────────
    // Maps to: currency VARCHAR(10) DEFAULT 'BDT'
    @Column(name = "currency", nullable = false, length = 10)
    @Builder.Default
    private String currency = "BDT";

    // Maps to: theme ENUM('light','dark') DEFAULT 'light'
    @Enumerated(EnumType.STRING)
    @Column(name = "theme", nullable = false)
    @Builder.Default
    private Theme theme = Theme.light;

    // ── STATUS ───────────────────────────────────────────────────
    // Maps to: is_active TINYINT(1) DEFAULT 1
    @Column(name = "is_active", nullable = false)
    @Builder.Default
    private Boolean isActive = true;

    // ── TIMESTAMPS ───────────────────────────────────────────────
    // Maps to: created_at DATETIME DEFAULT CURRENT_TIMESTAMP
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    // Maps to: updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
    @Column(name = "updated_at", nullable = false)
    private LocalDateTime updatedAt;

    // ── JPA LIFECYCLE HOOKS ──────────────────────────────────────
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // ── ENUM — matches schema.sql ENUM('light','dark') ───────────
    public enum Theme {
        light, dark
    }
}
