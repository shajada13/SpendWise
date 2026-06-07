package com.spendwise.repository;

import com.spendwise.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * LOCATION : src/main/java/com/spendwise/repository/UserRepository.java
 * CONNECTS TO:
 *   - User.java                   (Step 4) → entity this repo manages
 *   - users table in schema.sql   (Step 2) → actual MySQL table
 *   - AuthService.java            (Step 4) → calls these methods
 *   - CustomUserDetailsService    (Step 4) → calls findByEmailAndIsActive
 *
 * Spring Data JPA auto-implements all methods at runtime.
 * No SQL needed — method names define the queries.
 */
@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    // SELECT * FROM users WHERE email = ?
    // Used by: AuthService.findByEmail(), CustomUserDetailsService
    Optional<User> findByEmail(String email);

    // SELECT COUNT(*) > 0 FROM users WHERE email = ?
    // Used by: AuthService.registerUser() — prevent duplicate emails
    boolean existsByEmail(String email);

    // SELECT * FROM users WHERE email = ? AND is_active = ?
    // Used by: CustomUserDetailsService — only allow active accounts to login
    Optional<User> findByEmailAndIsActive(String email, Boolean isActive);
}
