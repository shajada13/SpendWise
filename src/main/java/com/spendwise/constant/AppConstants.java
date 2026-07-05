package com.spendwise.constant;

/**
 * Application-wide constants
 */
public final class AppConstants {

    private AppConstants() {}

    // Application
    public static final String APP_NAME        = "SpendWise";
    public static final String APP_VERSION     = "1.0.0";
    public static final String CURRENCY        = "BDT";
    public static final String CURRENCY_SYMBOL = "৳";
    public static final String TIMEZONE        = "Asia/Dhaka";

    // Pagination
    public static final int DEFAULT_PAGE_SIZE  = 10;
    public static final int MAX_PAGE_SIZE      = 100;
    public static final String DEFAULT_SORT_BY = "createdAt";
    public static final String SORT_DESC       = "desc";

    // Budget Alert Thresholds
    public static final int BUDGET_WARNING_PERCENT  = 70;
    public static final int BUDGET_ALERT_PERCENT    = 90;
    public static final int BUDGET_EXCEEDED_PERCENT = 100;

    // Upload limits
    public static final long MAX_FILE_SIZE      = 5 * 1024 * 1024L; // 5MB
    public static final String[] ALLOWED_IMAGE_TYPES = {
            "image/jpeg", "image/png", "image/gif", "image/webp"
    };

    // Date formats
    public static final String DATE_FORMAT          = "yyyy-MM-dd";
    public static final String DATETIME_FORMAT      = "yyyy-MM-dd HH:mm:ss";
    public static final String DISPLAY_DATE_FORMAT  = "dd MMM yyyy";

    // Session keys
    public static final String SESSION_USER         = "loggedInUser";
    public static final String SESSION_CURRENCY     = "userCurrency";
}
