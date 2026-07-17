package com.spendwise;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Entry point of the SpendWise application.
 * SpendWise is a smart expense tracker built for university students,
 * allowing them to track expenses, income, budgets, savings goals and
 * view analytical reports of their financial activity.
 */
@SpringBootApplication
public class SpendWiseApplication {

    public static void main(String[] args) {
        SpringApplication.run(SpendWiseApplication.class, args);
    }
}
