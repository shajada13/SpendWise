package com.spendwise.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${app.upload.dir:uploads/}")
    private String uploadDir;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/").setCachePeriod(3600);
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/").setCachePeriod(3600);
        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/").setCachePeriod(3600);
        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/").setCachePeriod(3600);
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadDir).setCachePeriod(3600);
    }

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/login").setViewName("pages/auth/login");
        registry.addViewController("/register").setViewName("pages/auth/register");
        registry.addViewController("/forgot-password").setViewName("pages/auth/forgot-password");
        registry.addViewController("/reset-password").setViewName("pages/auth/reset-password");
        registry.addViewController("/404").setViewName("pages/error/404");
        registry.addViewController("/500").setViewName("pages/error/500");
    }
}
