package com.spendwise.util;

import java.util.regex.Pattern;

/**
 * Common validation utility methods
 */
public final class ValidationUtil {

    private ValidationUtil() {}

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Za-z0-9+_.-]+@(.+)$");
    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^01[3-9]\\d{8}$");

    public static boolean isValidEmail(String email) {
        if (email == null || email.isBlank()) return false;
        return EMAIL_PATTERN.matcher(email).matches();
    }

    public static boolean isValidBdPhone(String phone) {
        if (phone == null || phone.isBlank()) return false;
        return PHONE_PATTERN.matcher(phone).matches();
    }

    public static boolean isNullOrEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    public static boolean isPositive(double amount) {
        return amount > 0;
    }
}
