package com.spendwise.util;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * Utility class for building uniform API responses
 */
public final class ResponseUtil {

    private ResponseUtil() {}

    public static ResponseEntity<Map<String, Object>> success(String message, Object data) {
        Map<String, Object> response = new HashMap<>();
        response.put("success",   true);
        response.put("status",    HttpStatus.OK.value());
        response.put("message",   message);
        response.put("data",      data);
        response.put("timestamp", LocalDateTime.now().toString());
        return ResponseEntity.ok(response);
    }

    public static ResponseEntity<Map<String, Object>> success(String message) {
        return success(message, null);
    }

    public static ResponseEntity<Map<String, Object>> created(String message, Object data) {
        Map<String, Object> response = new HashMap<>();
        response.put("success",   true);
        response.put("status",    HttpStatus.CREATED.value());
        response.put("message",   message);
        response.put("data",      data);
        response.put("timestamp", LocalDateTime.now().toString());
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    public static ResponseEntity<Map<String, Object>> error(String message, HttpStatus status) {
        Map<String, Object> response = new HashMap<>();
        response.put("success",   false);
        response.put("status",    status.value());
        response.put("message",   message);
        response.put("timestamp", LocalDateTime.now().toString());
        return ResponseEntity.status(status).body(response);
    }
}
