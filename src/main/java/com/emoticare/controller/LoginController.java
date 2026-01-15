package com.emoticare.controller;

import com.emoticare.model.User;
import com.emoticare.service.UserService;
import com.emoticare.dao.UserDAO;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class LoginController {

    @Autowired
    private UserService userService;

    private final UserDAO userDAO = new UserDAO();

    @GetMapping("/login")
    public String showLoginForm() {
        return "login";
    }

    @PostMapping("/login")
    public String processLogin(@RequestParam String username,
                               @RequestParam String password,
                               HttpSession session,
                               Model model) throws Exception {

        if (userService.validateCredentials(username, password)) {
            // Ambil user lengkap
            User user = userDAO.getUserByUsername(username);

            // Simpan ke session
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());

            // Redirect berdasarkan role_id
            switch (user.getRoleId()) {
                case 1:
                    return "redirect:/student/dashboard";
                case 2:
                    return "redirect:/faculty/dashboard";
                case 3:
                    return "redirect:/pro/dashboard";      // role lain
                case 4:
                    return "redirect:/admin/dashboard";   // admin
                default:
                    return "redirect:/";
            }

        } else {
            model.addAttribute("error", "Invalid username or password.");
            return "login";
        }
    }
}
