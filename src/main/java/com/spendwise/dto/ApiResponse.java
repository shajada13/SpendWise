package com.spendwise.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * LOCATION: src/main/java/com/spendwise/dto/ApiResponse.java
 * CONNECTS TO: All Controllers — universal JSON response wrapper
 *
 * SUCCESS: { "success": true,  "message": "...", "data": {...} }
 * ERROR:   { "success": false, "message": "...", "data": null  }
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ApiResponse<T> {

    private boolean success;
    private String message;
    private T data;

    // Quick success factory
    public static <T> ApiResponse<T> success(String message, T data) {
        return new ApiResponse<>(true, message, data);
    }

    // Quick success without data
    public static <T> ApiResponse<T> success(String message) {
        return new ApiResponse<>(true, message, null);
    }

    // Quick error factory
    public static <T> ApiResponse<T> error(String message) {
        return new ApiResponse<>(false, message, null);
    }
}
