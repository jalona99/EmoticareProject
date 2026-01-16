package com.emoticare.controller;

import com.emoticare.model.User;
import com.emoticare.service.AssessmentService;
import com.emoticare.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Date;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminDashboardController {

    /**
     * Check apakah user adalah admin (roleId = 4)
     */
    private boolean isAdmin(User user, HttpSession session) {
        if (user != null && user.getRoleId() == 4) return true;
        Integer roleId = (Integer) session.getAttribute("roleId");
        return roleId != null && roleId == 4;
    }

    /**
     * Admin Dashboard - Main page setelah login
     */
    @GetMapping("/dashboard")
    public String adminDashboard(HttpSession session, Model model) {
        
        User current = (User) session.getAttribute("user");
        
        // Jika bukan admin, redirect ke login
        if (!isAdmin(current, session)) {
            System.out.println("[AdminDashboardController] Access Denied for user: " + (current != null ? current.getUsername() : "null"));
            return "redirect:/login";
        }

        try {
            // Get statistics untuk dashboard
            int totalAssessments = AssessmentService.getTotalAssessments();
            int totalUsers = UserService.getTotalUsers();
            Map<String, Integer> riskStats = AssessmentService.getAssessmentRiskLevelStats();
            
            // Add ke model untuk display di JSP
            model.addAttribute("username", current.getUsername());
            model.addAttribute("userId", current.getId());
            model.addAttribute("totalAssessments", totalAssessments);
            model.addAttribute("totalUsers", totalUsers);
            model.addAttribute("riskStats", riskStats);
            model.addAttribute("systemDate", new Date());
            
            // Count high risk untuk card
            int highRisk = riskStats.getOrDefault("HIGH", 0);
            model.addAttribute("highRiskCount", highRisk);
            
            // Default completed today = 0 (bisa ditambah logic kedepan)
            model.addAttribute("completedToday", 0);
            
            return "admin_dashboard";
            
        } catch (Exception e) {
            System.err.println("Error loading admin dashboard: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Error loading dashboard data");
            return "error";
        }
    }

    /**
     * Fallback redirect dari /admin ke /admin/dashboard
     */
    @GetMapping
    public String redirectToDashboard() {
        return "redirect:/admin/dashboard";
    }
}