package com.spendwise.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Global Exception Handler
 * Handles all exceptions centrally and returns proper JSON responses
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    // ---- Resource Not Found ----
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<Map<String, Object>> handleNotFound(
            ResourceNotFoundException ex) {
        return buildResponse(HttpStatus.NOT_FOUND, ex.getMessage());
    }

    // ---- Unauthorized ----
    @ExceptionHandler(UnauthorizedException.class)
    public ResponseEntity<Map<String, Object>> handleUnauthorized(
            UnauthorizedException ex) {
        return buildResponse(HttpStatus.UNAUTHORIZED, ex.getMessage());
    }

    // ---- Bad Request ----
    @ExceptionHandler(BadRequestException.class)
    public ResponseEntity<Map<String, Object>> handleBadRequest(
            BadRequestException ex) {
        return buildResponse(HttpStatus.BAD_REQUEST, ex.getMessage());
    }

    // ---- Duplicate Resource ----
    @ExceptionHandler(DuplicateResourceException.class)
    public ResponseEntity<Map<String, Object>> handleDuplicate(
            DuplicateResourceException ex) {
        return buildResponse(HttpStatus.CONFLICT, ex.getMessage());
    }

    // ---- Budget Exceeded ----
    @ExceptionHandler(BudgetExceededException.class)
    public ResponseEntity<Map<String, Object>> handleBudgetExceeded(
            BudgetExceededException ex) {
        return buildResponse(HttpStatus.BAD_REQUEST, ex.getMessage());
    }

    // ---- Validation Errors (@Valid) ----
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidation(
            MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach(error -> {
            String field   = ((FieldError) error).getField();
            String message = error.getDefaultMessage();
            errors.put(field, message);
        });
        Map<String, Object> response = new HashMap<>();
        response.put("status",    HttpStatus.BAD_REQUEST.value());
        response.put("error",     "Validation Failed");
        response.put("errors",    errors);
        response.put("timestamp", LocalDateTime.now().toString());
        return ResponseEntity.badRequest().body(response);
    }

    // ---- 404 Handler ----
    @ExceptionHandler(NoHandlerFoundException.class)
    public ResponseEntity<Map<String, Object>> handleNoHandler(
            NoHandlerFoundException ex) {
        return buildResponse(HttpStatus.NOT_FOUND, "Page not found.");
    }

    // ---- Generic Fallback ----
    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, Object>> handleGeneric(Exception ex) {
        return buildResponse(HttpStatus.INTERNAL_SERVER_ERROR,
                "Something went wrong. Please try again.");
    }

    // ---- Helper method ----
    private ResponseEntity<Map<String, Object>> buildResponse(
            HttpStatus status, String message) {
        Map<String, Object> body = new HashMap<>();
        body.put("status",    status.value());
        body.put("error",     status.getReasonPhrase());
        body.put("message",   message);
        body.put("timestamp", LocalDateTime.now().toString());
        return ResponseEntity.status(status).body(body);
    }
}
