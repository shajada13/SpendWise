package com.spendwise.service;

import com.spendwise.model.User;
import com.spendwise.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.Service;

import java.util.Collections;

/**
 * LOCATION : src/main/java/com/spendwise/service/CustomUserDetailsService.java
 * CONNECTS TO:
 *   - SecurityConfig.java  (Step 4) → registered as userDetailsService bean
 *   - UserRepository.java  (Step 4) → loads user from MySQL by email
 *   - User.java            (Step 4) → User entity
 *   - users table          (Step 2) → actual data source
 *
 * PURPOSE:
 *   Spring Security calls loadUserByUsername() automatically
 *   during every login attempt to verify credentials.
 */
@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {

        // Load user from MySQL users table via UserRepository
        User user = userRepository.findByEmailAndIsActive(email.toLowerCase().trim(), true)
                .orElseThrow(() ->
                        new UsernameNotFoundException("No active account found for: " + email));

        // Return Spring Security UserDetails object
        return new org.springframework.security.core.userdetails.User(
                user.getEmail(),
                user.getPassword(),
                Collections.emptyList()  // No roles needed for this app
        );
    }
}
