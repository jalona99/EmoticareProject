package com.emoticare.controller;

import com.emoticare.model.Assessment;
import com.emoticare.model.AssessmentResponse;
import com.emoticare.model.AssessmentType;
import com.emoticare.model.User;
import com.emoticare.service.AssessmentService;
import com.emoticare.dao.AssessmentTypeDAO;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/assessments")
public class AdminAssessmentController {

    private boolean isAdmin(User user) {
    return user != null && user.getRoleId() == 4;  // ✅ BENAR
}


    // List semua assessments
    @GetMapping
    public String listAssessments(HttpSession session, Model model,
                                   @RequestParam(required = false) String status,
                                   @RequestParam(required = false) Integer typeId) {
        
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current)) {
            return "redirect:/login";
        }

        List<Assessment> assessments;
        if (status != null || typeId != null) {
            assessments = AssessmentService.getAssessmentsByFilter(status, typeId);
        } else {
            assessments = AssessmentService.getAllAssessments();
        }

        List<AssessmentType> types = AssessmentService.getAllAssessmentTypes();
        Map<String, Integer> riskStats = AssessmentService.getAssessmentRiskLevelStats();
        int totalAssessments = AssessmentService.getTotalAssessments();

        model.addAttribute("username", current.getUsername());
        model.addAttribute("assessments", assessments);
        model.addAttribute("assessmentTypes", types);
        model.addAttribute("riskLevelStats", riskStats);
        model.addAttribute("totalAssessments", totalAssessments);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("selectedTypeId", typeId);

        return "admin_assessments";
    }

    // View detail satu assessment
    @GetMapping("/{assessmentId}")
    public String viewDetail(@PathVariable int assessmentId,
                             HttpSession session,
                             Model model) {
        
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current)) {
            return "redirect:/login";
        }

        Map<String, Object> detail = AssessmentService.getAssessmentDetail(assessmentId);
        if (detail.isEmpty()) {
            model.addAttribute("error", "Assessment not found");
            return "error";
        }

        List<AssessmentResponse> responses = AssessmentService.getResponsesForAssessment(assessmentId);

        model.addAttribute("username", current.getUsername());
        model.addAttribute("assessment", detail);
        model.addAttribute("responses", responses);
        model.addAttribute("responseCount", responses.size());

        return "admin_assessment_detail";
    }

    // Filter by status
    @GetMapping("/status/{status}")
    public String filterByStatus(@PathVariable String status,
                                 HttpSession session,
                                 Model model) {
        
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current)) {
            return "redirect:/login";
        }

        List<Assessment> assessments = AssessmentService.getAssessmentsByFilter(status, null);
        List<AssessmentType> types = AssessmentService.getAllAssessmentTypes();

        model.addAttribute("username", current.getUsername());
        model.addAttribute("assessments", assessments);
        model.addAttribute("assessmentTypes", types);
        model.addAttribute("selectedStatus", status);

        return "admin_assessments";
    }

    // Filter by type
    @GetMapping("/type/{typeId}")
    public String filterByType(@PathVariable int typeId,
                               HttpSession session,
                               Model model) {
        
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current)) {
            return "redirect:/login";
        }

        List<Assessment> assessments = AssessmentService.getAssessmentsByFilter(null, typeId);
        List<AssessmentType> types = AssessmentService.getAllAssessmentTypes();

        model.addAttribute("username", current.getUsername());
        model.addAttribute("assessments", assessments);
        model.addAttribute("assessmentTypes", types);
        model.addAttribute("selectedTypeId", typeId);

        return "admin_assessments";
    }
}
