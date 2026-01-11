package com.emoticare.controller;

import com.emoticare.service.ReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin/reports")
public class AdminReportingController {

    @Autowired
    private ReportService reportService;

    @GetMapping
    public String showReports(Model model) {
        try {
            model.addAttribute("moduleStats", reportService.getModuleCompletionStats());
            model.addAttribute("quizScores", reportService.getAllQuizScores());
            model.addAttribute("userBadges", reportService.getAllBadgesEarned());
            model.addAttribute("forumStats", reportService.getForumStats());
            return "admin/reporting-dashboard";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Error loading reports.");
            return "error";
        }
    }
}
