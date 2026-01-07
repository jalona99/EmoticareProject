package com.emoticare.controller;

import com.emoticare.model.User;
import com.emoticare.model.Role;
import com.emoticare.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.sql.SQLException;
import java.util.*;

@Controller
@RequestMapping("")
public class RegistrationController {
    private static final Logger logger = LoggerFactory.getLogger(RegistrationController.class);
    
    @Autowired
    private UserService userService;

    /**
     * GET /register - Tampilkan form registrasi
     */
    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
    User user = new User();
    // Secara otomatis set roleId ke 1 (Student) agar user tidak perlu memilih
    user.setRoleId(1); 
    model.addAttribute("user", user);
    
    // Kita tidak perlu lagi memuat list roles ke model karena dropdown akan dihapus
    return "register";
}

    /**
     * POST /register - Proses registrasi user
     */
    @PostMapping("/register")
    public String processRegistration(
            @Valid @ModelAttribute("user") User user,
            BindingResult bindingResult,
            Model model) {
        
        try {
            // 1. Cek validation errors dari form
            if (bindingResult.hasErrors()) {
                // Reload roles untuk form
                List<Role> roles = userService.getAllRoles();
                model.addAttribute("roles", roles);
                logger.warn("Validation errors for user: {}", user.getUsername());
                return "register";
            }
            
            // 2. Proses registrasi di service
            Map<String, String> result = userService.registerUser(user);
            
            if (result.containsKey("success")) {
                model.addAttribute("successMessage", result.get("success"));
                logger.info("User {} registered successfully", user.getUsername());
                return "success";
            } else {
                model.addAttribute("error", result.get("error"));
                // Reload roles untuk form
                List<Role> roles = userService.getAllRoles();
                model.addAttribute("roles", roles);
                return "register";
            }
            
        } catch (SQLException e) {
            logger.error("Database error during registration", e);
            model.addAttribute("error", "Terjadi kesalahan database: " + e.getMessage());
            return "error";
        } catch (Exception e) {
            logger.error("Unexpected error during registration", e);
            model.addAttribute("error", "Terjadi kesalahan sistem");
            return "error";
        }
    }

    /**
     * GET / - Home page
     */
    @GetMapping("/")
    public String home() {
        return "index";
    }
}
