package com.spendwise.controller;

import com.spendwise.dto.ApiResponse;
import com.spendwise.dto.RegisterRequest;
import com.spendwise.model.User;
import com.spendwise.service.AuthService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

/**
 * LOCATION : src/main/java/com/spendwise/controller/AuthController.java
 * CONNECTS TO:
 *   - AuthService.java           (Step 4) → business logic
 *   - SecurityConfig.java        (Step 4) → login/logout routes
 *   - LoginRequest.java          (Step 4) → login form data
 *   - RegisterRequest.java       (Step 4) → register form data
 *   - ApiResponse.java           (Step 3) → JSON response wrapper
 *   - templates/auth/login.html  (Step 6) → login/register page
 *   - users table                (Step 2) → where users are stored
 */
@Controller
@RequiredArgsConstructor
public class AuthController {

    private final AuthService      authService;
    private final AuthenticationManager authenticationManager;

    // ────────────────────────────────────────────────────────────
    // GET /login  → Show login & register page
    // Template  : templates/auth/login.html  (Step 6)
    // ────────────────────────────────────────────────────────────
    @GetMapping("/login")
    public String loginPage(
            @RequestParam(required = false) String error,
            @RequestParam(required = false) String logout,
            @RequestParam(required = false) String expired,
            @RequestParam(required = false) String registered,
            Model model) {

        // Pass messages to Thymeleaf template
        if (error    != null) model.addAttribute("errorMsg",      "Invalid email or password.");
        if (logout   != null) model.addAttribute("successMsg",    "You have been logged out.");
        if (expired  != null) model.addAttribute("errorMsg",      "Session expired. Please login again.");
        if (registered != null) model.addAttribute("successMsg",  "Account created! Please login.");

        return "auth/login";   // → templates/auth/login.html
    }

    // ────────────────────────────────────────────────────────────
    // POST /api/auth/register  → Register new user
    // Called by: login.html register form (Step 6)
    // Returns  : JSON { success, message, data }
    // ────────────────────────────────────────────────────────────
    @PostMapping("/api/auth/register")
    @ResponseBody
    public ResponseEntity<ApiResponse<Void>> register(
            @Valid @RequestBody RegisterRequest request,
            BindingResult bindingResult) {

        // 1. Validate form fields (@NotBlank, @Email, @Size)
        if (bindingResult.hasErrors()) {
            String errorMsg = bindingResult.getAllErrors()
                    .get(0).getDefaultMessage();
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(errorMsg));
        }

        // 2. Call AuthService → saves to MySQL users table (Step 2)
        try {
            authService.registerUser(request);
            return ResponseEntity.ok(
                ApiResponse.success("Account created successfully! Please login.")
            );
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest()
                    .body(ApiResponse.error(e.getMessage()));
        }
    }

    // ────────────────────────────────────────────────────────────
    // GET /dashboard  → Redirect to dashboard after login
    // Note: Actual login POST is handled by Spring Security
    //       via SecurityConfig loginProcessingUrl("/api/auth/login")
    // ────────────────────────────────────────────────────────────
    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {

        // Get logged-in user's email from Spring Security context
        Authentication auth = SecurityContextHolder
                .getContext().getAuthentication();

        if (auth != null && auth.isAuthenticated()
                && !auth.getName().equals("anonymousUser")) {

            // Load full user object from DB and store in session
            authService.findByEmail(auth.getName()).ifPresent(user -> {
                session.setAttribute("userId",   user.getId());
                session.setAttribute("userName", user.getFullName());
                session.setAttribute("userEmail", user.getEmail());
                model.addAttribute("user", user);
            });
        }

        return "dashboard/index";  // → templates/dashboard/index.html (Step 7)
    }

    // ────────────────────────────────────────────────────────────
    // GET /api/auth/me  → Returns current logged-in user info (JSON)
    // Used by frontend JS to get current user details
    // ────────────────────────────────────────────────────────────
    @GetMapping("/api/auth/me")
    @ResponseBody
    public ResponseEntity<ApiResponse<User>> getCurrentUser(HttpSession session) {
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return ResponseEntity.status(401)
                    .body(ApiResponse.error("Not authenticated"));
        }
        try {
            User user = authService.getUserById(userId);
            user.setPassword(null); // Never send password in response
            return ResponseEntity.ok(ApiResponse.success("User data", user));
        } catch (RuntimeException e) {
            return ResponseEntity.status(404)
                    .body(ApiResponse.error(e.getMessage()));
        }
    }
}
