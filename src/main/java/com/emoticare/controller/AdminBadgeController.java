package com.emoticare.controller;

import com.emoticare.model.Badge;
import com.emoticare.service.LearningService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/badges")
public class AdminBadgeController {

    @Autowired
    private LearningService learningService;

    @GetMapping
    public String listBadges(Model model) {
        try {
            model.addAttribute("badges", learningService.getAllBadges());
            model.addAttribute("modules", learningService.getAllModules()); // Needed for creating new badges
            return "admin/badge-list";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/dashboard?error=badge_list_error";
        }
    }

    @PostMapping("/create")
    public String createBadge(@RequestParam("name") String name,
            @RequestParam("description") String description,
            @RequestParam("iconUrl") String iconUrl,
            @RequestParam(value = "criteriaModuleId", required = false) Integer criteriaModuleId) {
        try {
            Badge badge = new Badge();
            badge.setName(name);
            badge.setDescription(description);
            badge.setIconUrl(iconUrl);
            badge.setCriteriaModuleId(criteriaModuleId);

            learningService.createBadge(badge);
            return "redirect:/admin/badges";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/badges?error=create_failed";
        }
    }

    @PostMapping("/delete")
    public String deleteBadge(@RequestParam("id") int id) {
        try {
            learningService.deleteBadge(id);
            return "redirect:/admin/badges";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/badges?error=delete_failed";
        }
    }
}
