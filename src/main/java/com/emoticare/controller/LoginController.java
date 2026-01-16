package com.emoticare.controller;

import com.emoticare.model.User;
import com.emoticare.service.UserService;
import com.emoticare.dao.UserDAO;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class LoginController {
    private static final Logger logger = LoggerFactory.getLogger(LoginController.class);

    @Autowired
    private UserService userService;

    private UserDAO userDAO = new UserDAO();

    /**
     * GET /login - Tampilkan halaman login
     */
    @GetMapping("/login")
    public String showLoginForm() {
        return "login";
    }

    /**
     * POST /login - Proses autentikasi user
     */
    @PostMapping("/login")
    public String processLogin(@RequestParam String username,
                             @RequestParam String password,
                             HttpSession session,
                             Model model) {
        
        logger.info("Login attempt for user: {}", username);

        if (userService.validateCredentials(username, password)) {
            try {
                User user = userDAO.getUserByUsername(username);
                if (user != null) {
                    session.setAttribute("user", user);
                    session.setAttribute("userId", user.getId()); // NEW: Set userId for compatibility
                    session.setAttribute("roleId", user.getRoleId()); // NEW: Set roleId for interceptor
                    logger.info("User {} logged in successfully with role: {}", username, user.getRoleId());
                    
                    // Redirect based on role
                    if (user.getRoleId() == 4) { // Admin
                        return "redirect:/admin/dashboard";
                    } else { // Student, Faculty, Counselor
                        return "redirect:/student/dashboard";
                    }
                }
            } catch (Exception e) {
                logger.error("Error retrieving user details for session", e);
                model.addAttribute("error", "An internal error occurred.");
                return "login";
            }
        }

        logger.warn("Login failed for user: {}", username);
        model.addAttribute("error", "Username atau password salah!");
        return "login";
    }
}
