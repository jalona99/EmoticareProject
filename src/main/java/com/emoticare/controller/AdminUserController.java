package com.emoticare.controller;

import com.emoticare.model.User;
import com.emoticare.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/users")
public class AdminUserController {

    @Autowired
    private UserService userService;

    private boolean isAdmin(User user) {
    return user != null && user.getRoleId() == 4;  // ✅ BENAR
}


    // Halaman daftar semua user
    @GetMapping
    public String listUsers(HttpSession session, Model model) {
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current)) {
            return "redirect:/login";
        }

        model.addAttribute("username", current.getUsername());
        model.addAttribute("users", userService.getAllUsers());
        return "admin_users"; // JSP baru yang nanti Anda buat
    }

    // Ubah role user (misal dari 1 -> 3)
    @PostMapping("/change-role")
    public String changeRole(HttpSession session,
                             @RequestParam int userId,
                             @RequestParam int roleId) {
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current)) {
            return "redirect:/login";
        }

        // opsional: jangan izinkan admin mengubah role dirinya sendiri
        if (current.getId() != userId) {
            userService.changeUserRole(userId, roleId);
        }
        return "redirect:/admin/users";
    }

    // Aktifkan / nonaktifkan user
    @PostMapping("/set-active")
    public String setActive(HttpSession session,
                            @RequestParam int userId,
                            @RequestParam boolean active) {
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current)) {
            return "redirect:/login";
        }

        // opsional: jangan izinkan admin menonaktifkan dirinya sendiri
        if (current.getId() != userId) {
            userService.setUserActive(userId, active);
        }
        return "redirect:/admin/users";
    }
}


