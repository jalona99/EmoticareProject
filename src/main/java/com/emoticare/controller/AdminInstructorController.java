package com.emoticare.controller;

import com.emoticare.dao.ProfessionalDAO;
import com.emoticare.model.ProfessionalProfile;
import com.emoticare.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.sql.SQLException;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Controller
@RequestMapping("/admin/instructors")
public class AdminInstructorController {

    private static final Pattern INLINE_URL_PATTERN =
            Pattern.compile("data-url\\s*=\\s*['\\\"]([^'\\\"]+)['\\\"]", Pattern.CASE_INSENSITIVE);
    private static final Pattern URL_FALLBACK_PATTERN =
            Pattern.compile("(https?://[^\\s'\\\"]*calendly\\.com[^\\s'\\\"]*)", Pattern.CASE_INSENSITIVE);

    private final ProfessionalDAO professionalDAO = new ProfessionalDAO();

    private boolean isAdmin(User user) {
        return user != null && user.getRoleId() == 4;
    }

    @GetMapping
    public String showManagePage(HttpSession session, Model model) {
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current)) {
            return "redirect:/login";
        }
        return renderManagePage(current, model, null);
    }

    @GetMapping("/edit/{id}")
    public String showEditPage(@PathVariable int id, HttpSession session, Model model) {
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current)) {
            return "redirect:/login";
        }

        try {
            ProfessionalProfile editProfile = professionalDAO.getById(id);
            if (editProfile == null) {
                return "redirect:/admin/instructors?error=not_found";
            }
            return renderManagePage(current, model, editProfile);
        } catch (SQLException e) {
            e.printStackTrace();
            return "redirect:/admin/instructors?error=not_found";
        }
    }

    @PostMapping("/create")
    public String createInstructor(HttpSession session,
                                   @RequestParam String name,
                                   @RequestParam(required = false) String credentials,
                                   @RequestParam(required = false) String specialty,
                                   @RequestParam(required = false) String bio,
                                   @RequestParam(required = false) String calendlyUrl,
                                   @RequestParam(required = false) String calendlyInlineCode) {
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current)) {
            return "redirect:/login";
        }

        String calendlyValue = pickCalendlyValue(calendlyInlineCode, calendlyUrl);
        if (isBlank(name) || isBlank(credentials) || isBlank(specialty) || isBlank(bio) || isBlank(calendlyValue)) {
            return "redirect:/admin/instructors?error=missing_fields";
        }

        ProfessionalProfile profile = new ProfessionalProfile();
        profile.setName(name.trim());
        profile.setCredentials(credentials.trim());
        profile.setSpecialty(specialty.trim());
        profile.setBio(bio.trim());
        profile.setCalendlyUrl(calendlyValue);

        try {
            int profileId = professionalDAO.createProfessionalProfile(profile);
            if (profileId <= 0) {
                return "redirect:/admin/instructors?error=profile_create_failed";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "redirect:/admin/instructors?error=profile_create_failed";
        }

        return "redirect:/admin/instructors?success=created";
    }

    @PostMapping("/update")
    public String updateInstructor(HttpSession session,
                                   @RequestParam int id,
                                   @RequestParam String name,
                                   @RequestParam(required = false) String credentials,
                                   @RequestParam(required = false) String specialty,
                                   @RequestParam(required = false) String bio,
                                   @RequestParam(required = false) String calendlyUrl,
                                   @RequestParam(required = false) String calendlyInlineCode) {
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current)) {
            return "redirect:/login";
        }

        String calendlyValue = pickCalendlyValue(calendlyInlineCode, calendlyUrl);
        if (isBlank(name) || isBlank(credentials) || isBlank(specialty) || isBlank(bio) || isBlank(calendlyValue)) {
            return "redirect:/admin/instructors?error=missing_fields";
        }

        ProfessionalProfile profile = new ProfessionalProfile();
        profile.setId(id);
        profile.setName(name.trim());
        profile.setCredentials(credentials.trim());
        profile.setSpecialty(specialty.trim());
        profile.setBio(bio.trim());
        profile.setCalendlyUrl(calendlyValue);

        try {
            boolean updated = professionalDAO.updateProfessionalProfile(profile);
            if (!updated) {
                return "redirect:/admin/instructors?error=profile_update_failed";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "redirect:/admin/instructors?error=profile_update_failed";
        }

        return "redirect:/admin/instructors?success=updated";
    }

    @PostMapping("/delete")
    public String deleteInstructor(HttpSession session, @RequestParam int id) {
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current)) {
            return "redirect:/login";
        }

        try {
            boolean deleted = professionalDAO.deleteProfessionalProfile(id);
            if (!deleted) {
                return "redirect:/admin/instructors?error=profile_delete_failed";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "redirect:/admin/instructors?error=profile_delete_failed";
        }

        return "redirect:/admin/instructors?success=deleted";
    }

    private String renderManagePage(User current, Model model, ProfessionalProfile editProfile) {
        model.addAttribute("username", current.getUsername());
        try {
            List<ProfessionalProfile> professionals = professionalDAO.getAllProfessionals();
            model.addAttribute("professionals", professionals);
        } catch (SQLException e) {
            e.printStackTrace();
            return "redirect:/admin/dashboard?error=professional_load_failed";
        }

        if (editProfile != null) {
            model.addAttribute("editProfile", editProfile);
            model.addAttribute("isEdit", true);
        } else {
            model.addAttribute("isEdit", false);
        }

        return "admin/telehealth-manage";
    }

    private String pickCalendlyValue(String inlineCode, String url) {
        String extracted = extractCalendlyUrl(inlineCode);
        if (!isBlank(extracted)) {
            return extracted.trim();
        }
        if (!isBlank(url)) {
            return url.trim();
        }
        return null;
    }

    private String extractCalendlyUrl(String inlineCode) {
        if (isBlank(inlineCode)) {
            return null;
        }
        Matcher matcher = INLINE_URL_PATTERN.matcher(inlineCode);
        if (matcher.find()) {
            return matcher.group(1);
        }
        Matcher fallback = URL_FALLBACK_PATTERN.matcher(inlineCode);
        if (fallback.find()) {
            return fallback.group(1);
        }
        return null;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
