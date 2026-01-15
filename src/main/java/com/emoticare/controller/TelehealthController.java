package com.emoticare.controller;

import com.emoticare.dao.ProfessionalDAO;
import com.emoticare.model.ProfessionalProfile;
import com.emoticare.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.sql.SQLException;
import java.util.List;

@Controller
@RequestMapping("/telehealth")
public class TelehealthController {

    private final ProfessionalDAO professionalDAO = new ProfessionalDAO();

    @GetMapping("")
    public String showProfessionalsList(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            List<ProfessionalProfile> professionals = professionalDAO.getAllProfessionals();
            model.addAttribute("professionals", professionals);
            model.addAttribute("username", user.getUsername());
        } catch (SQLException e) {
            e.printStackTrace();
            return "error";
        }

        return "telehealth_list";
    }

    @GetMapping("/schedule/{id}")
    public String showSchedulePage(@PathVariable int id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            ProfessionalProfile profile = professionalDAO.getById(id);
            if (profile == null) {
                return "error";
            }
            model.addAttribute("profile", profile);
        } catch (SQLException e) {
            e.printStackTrace();
            return "error";
        }

        return "telehealth_schedule";
    }
}
