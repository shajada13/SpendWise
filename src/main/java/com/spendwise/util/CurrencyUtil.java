package com.spendwise.util;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;

/**
 * Currency utility methods for BDT formatting
 */
public final class CurrencyUtil {

    private CurrencyUtil() {}

    public static final String CURRENCY_SYMBOL = "৳";
    private static final DecimalFormat FORMATTER =
            new DecimalFormat("#,##0.00");

    public static String format(BigDecimal amount) {
        if (amount == null) return CURRENCY_SYMBOL + "0.00";
        return CURRENCY_SYMBOL + FORMATTER.format(amount);
    }

    public static String format(double amount) {
        return CURRENCY_SYMBOL + FORMATTER.format(
                BigDecimal.valueOf(amount).setScale(2, RoundingMode.HALF_UP));
    }

    public static double calculatePercentage(double part, double total) {
        if (total == 0) return 0;
        return Math.round((part / total) * 100.0 * 100.0) / 100.0;
    }
}
