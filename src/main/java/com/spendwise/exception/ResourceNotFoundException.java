package com.spendwise.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

/**
 * LOCATION : src/main/java/com/spendwise/exception/ResourceNotFoundException.java
 * CONNECTS TO:
 *   - GlobalExceptionHandler.java (Step 4) → catches this and returns 404
 *   - AuthService.java            (Step 4) → throws when user not found
 *   - All future services         (Step 5) → throws when any record missing
 */
@ResponseStatus(HttpStatus.NOT_FOUND)
public class ResourceNotFoundException extends RuntimeException {

    public ResourceNotFoundException(String message) {
        super(message);
    }

    public ResourceNotFoundException(String resource, Long id) {
        super(resource + " not found with id: " + id);
    }
}
