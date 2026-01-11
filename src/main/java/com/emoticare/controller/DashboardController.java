package com.emoticare.controller;

import com.emoticare.model.User;
import com.emoticare.model.AssessmentType;
import com.emoticare.service.AssessmentService;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import com.emoticare.service.LearningService;
import java.sql.SQLException;

@Controller
public class DashboardController {

    @Autowired
    private LearningService learningService;

    @GetMapping("/student/dashboard")
    public String showStudentDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleId() != 1) {
            return "redirect:/login";
        }

        List<AssessmentType> assessmentTypes = AssessmentService.getAllAssessmentTypes();

        model.addAttribute("username", user.getUsername());
        model.addAttribute("userId", user.getId());
        model.addAttribute("assessmentTypes", assessmentTypes);

        try {
            model.addAttribute("badges", learningService.getUserBadges(user.getId()));
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return "student_dashboard";
    }
}
