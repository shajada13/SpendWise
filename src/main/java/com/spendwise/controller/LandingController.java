package com.spendwise.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Landing page controller
 * Handles root URL redirect
 */
@Controller
public class LandingController {

    /**
     * Root URL - redirects to login
     */
    @GetMapping("/")
    public String home() {
        return "redirect:/login";
    }

    /**
     * Landing page
     */
    @GetMapping("/landing")
    public String landing() {
        return "landing";
    }
}
