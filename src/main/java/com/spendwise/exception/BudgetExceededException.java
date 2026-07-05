package com.spendwise.exception;

/**
 * BudgetExceededException
 */
public class BudgetExceededException extends RuntimeException {

    public BudgetExceededException(String message) {
        super(message);
    }

    public BudgetExceededException(String message, Throwable cause) {
        super(message, cause);
    }
}
