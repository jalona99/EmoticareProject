package com.emoticare.controller;

import com.emoticare.dao.ChatRiskAlertDAO;
import com.emoticare.model.ChatRiskAlert;
import com.emoticare.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.sql.SQLException;
import java.util.List;

@Controller
@RequestMapping("/admin/chat-alerts")
public class AdminChatAlertController {

    private final ChatRiskAlertDAO chatRiskAlertDAO = new ChatRiskAlertDAO();

    private boolean isAdmin(User user, HttpSession session) {
        if (user != null && user.getRoleId() == 4) return true;
        Integer roleId = (Integer) session.getAttribute("roleId");
        return roleId != null && roleId == 4;
    }

    @GetMapping
    public String showAlerts(HttpSession session, Model model) {
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current, session)) {
            return "redirect:/login";
        }

        try {
            List<ChatRiskAlert> alerts = chatRiskAlertDAO.getRecentAlerts(200);
            model.addAttribute("alerts", alerts);
            model.addAttribute("username", current.getUsername());
        } catch (SQLException e) {
            e.printStackTrace();
            model.addAttribute("error", "Failed to load chat risk alerts.");
        }

        return "admin/chat-alerts";
    }

    @PostMapping("/acknowledge")
    public String acknowledgeAlert(HttpSession session, @RequestParam int id) {
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current, session)) {
            return "redirect:/login";
        }

        try {
            chatRiskAlertDAO.acknowledgeAlert(id);
        } catch (SQLException e) {
            e.printStackTrace();
            return "redirect:/admin/chat-alerts?error=ack_failed";
        }

        return "redirect:/admin/chat-alerts?success=acknowledged";
    }
}
