package com.spendwise.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Date utility methods
 */
public final class DateUtil {

    private DateUtil() {}

    public static final String DATE_FORMAT     = "yyyy-MM-dd";
    public static final String DATETIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
    public static final String DISPLAY_FORMAT  = "dd MMM yyyy";

    public static String formatDate(LocalDate date) {
        if (date == null) return "";
        return date.format(DateTimeFormatter.ofPattern(DISPLAY_FORMAT));
    }

    public static String formatDateTime(LocalDateTime dateTime) {
        if (dateTime == null) return "";
        return dateTime.format(DateTimeFormatter.ofPattern(DATETIME_FORMAT));
    }

    public static LocalDate getCurrentDate() {
        return LocalDate.now();
    }

    public static int getCurrentMonth() {
        return LocalDate.now().getMonthValue();
    }

    public static int getCurrentYear() {
        return LocalDate.now().getYear();
    }

    public static String getMonthName(int month) {
        return LocalDate.of(2024, month, 1)
                .format(DateTimeFormatter.ofPattern("MMMM"));
    }
}
