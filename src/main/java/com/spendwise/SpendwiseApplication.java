package com.spendwise;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.scheduling.annotation.EnableScheduling;

import java.util.TimeZone;

/**
 * SpendWise - Personal Finance & Budget Management System
 * Main Application Entry Point
 *
 * @version 1.0.0
 */
@SpringBootApplication
@EnableJpaAuditing
@EnableScheduling
@EnableConfigurationProperties
public class SpendWiseApplication {

    public static void main(String[] args) {

        // Set default timezone to Asia/Dhaka (Bangladesh)
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Dhaka"));

        SpringApplication.run(SpendWiseApplication.class, args);

        System.out.println("""
                
                ╔══════════════════════════════════════════════════╗
                ║          SpendWise Application Started!          ║
                ║    Personal Finance & Budget Management System   ║
                ║--------------------------------------------------║
                ║  URL  : http://localhost:8080                    ║
                ║  Version: 1.0.0                                  ║
                ║  Currency: BDT (৳)  |  Timezone: Asia/Dhaka     ║
                ╚══════════════════════════════════════════════════╝
                """);
    }
}
