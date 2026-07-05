package com.spendwise.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.i18n.SessionLocaleResolver;

import java.util.Locale;

/**
 * Thymeleaf & Locale Configuration
 * - UTF-8 encoding
 * - Default locale
 * - Message source setup
 */
@Configuration
public class ThymeleafConfig {

    /**
     * Default locale resolver - English (can switch later)
     */
    @Bean
    public LocaleResolver localeResolver() {
        SessionLocaleResolver resolver = new SessionLocaleResolver();
        resolver.setDefaultLocale(Locale.ENGLISH);
        return resolver;
    }
}
