package com.spendwise.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;

/**
 * LOCATION : src/main/java/com/spendwise/config/WebConfig.java
 * CONNECTS TO:
 *   - application.properties (Step 3) → static resource paths
 *   - All HTML templates     (Step 6+) → served from /templates/
 *   - CSS/JS files           (Step 6+) → served from /static/
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    // ────────────────────────────────────────────────────────────
    // STATIC RESOURCES — CSS, JS, Images
    // Maps /css/**, /js/**, /images/** → classpath:/static/
    // ────────────────────────────────────────────────────────────
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/");

        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/");

        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/");
    }

    // ────────────────────────────────────────────────────────────
    // VIEW CONTROLLERS — Simple page redirects
    // Maps URL → Thymeleaf template without a Controller method
    // ────────────────────────────────────────────────────────────
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        // Root URL → redirect to dashboard (if logged in) or login
        registry.addRedirectViewController("/", "/dashboard");
    }
}
