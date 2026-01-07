package com.emoticare.controller;

import com.emoticare.dao.*;
import com.emoticare.model.*;
import com.emoticare.service.*;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Controller
@RequestMapping("/assessment")
public class AssessmentController {
    
    // =====================================================
    // STEP 1: Show Assessment Selection (Choose Your Assessment)
    // =====================================================
    @GetMapping("/select")
    public String selectAssessment(Model model, HttpSession session) {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        // Get all assessment types from database
        List<AssessmentType> types = AssessmentTypeDAO.getAllAssessmentTypes();
        model.addAttribute("assessmentTypes", types);
        
        return "assessment-selection";
    }
    
    // =====================================================
    // STEP 2: Start Assessment (Save to session, show disclaimer)
    // =====================================================
    @PostMapping("/start")
    public String startAssessment(
            @RequestParam("assessmentTypeId") int assessmentTypeId,
            HttpSession session,
            Model model) {
        
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        // Save selected type to session (BELUM buat record di database)
        session.setAttribute("selectedAssessmentTypeId", assessmentTypeId);
        
        // Get assessment type details untuk disclaimer
        AssessmentType type = AssessmentTypeDAO.getAssessmentTypeById(assessmentTypeId);
        model.addAttribute("assessmentType", type);
        
        // Arahkan ke disclaimer dulu (UC-011 Step 4-5)
        return "assessment-disclaimer";
    }
    
    // =====================================================
    // STEP 3: Confirm Disclaimer & Create Assessment Record
    // =====================================================
    @PostMapping("/confirm-disclaimer")
    public String confirmDisclaimer(HttpSession session, Model model) {
        Integer userId = (Integer) session.getAttribute("userId");
        Integer typeId = (Integer) session.getAttribute("selectedAssessmentTypeId");
        
        if (userId == null || typeId == null) {
            return "redirect:/assessment/select";
        }
        
        // BARU SEKARANG buat record assessment (setelah user setuju disclaimer)
        int assessmentId = AssessmentService.startAssessment(userId, typeId);
        
        if (assessmentId <= 0) {
            model.addAttribute("error", "Failed to start assessment");
            return "error";
        }
        
        // Redirect ke questionnaire
        return "redirect:/assessment/questionnaire?assessmentId=" + assessmentId;
    }
    
    // =====================================================
    // STEP 4: Show Questionnaire
    // =====================================================
    @GetMapping("/questionnaire")
    public String showQuestionnaire(
            @RequestParam("assessmentId") int assessmentId,
            HttpSession session,
            Model model) {
        
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        // Verify assessment belongs to this user
        Assessment assessment = AssessmentDAO.getAssessmentById(assessmentId);
        if (assessment == null || assessment.getUserId() != userId) {
            return "redirect:/assessment/select";
        }
        
        // Get questions
        List<AssessmentQuestion> questions = QuestionDAO.getQuestionsByType(assessment.getAssessmentTypeId());
        
        // Get assessment type
        AssessmentType type = AssessmentTypeDAO.getAssessmentTypeById(assessment.getAssessmentTypeId());
        
        // Convert questions to JSON for JavaScript
        try {
            ObjectMapper mapper = new ObjectMapper();
            String questionsJson = mapper.writeValueAsString(questions);
            model.addAttribute("questionsJson", questionsJson);
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("questionsJson", "[]");
        }
        
        model.addAttribute("assessmentId", assessmentId);
        model.addAttribute("assessmentType", type);
        model.addAttribute("totalQuestions", questions.size());
        
        return "assessment-questionnaire";
    }
    
    // =====================================================
    // STEP 5: Save Answer (Auto-save via AJAX)
    // =====================================================
    @PostMapping("/save-answer")
    @ResponseBody
    public Map<String, Object> saveAnswer(
            @RequestParam("assessmentId") int assessmentId,
            @RequestParam("questionId") int questionId,
            @RequestParam("scaleValue") int scaleValue,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.put("success", false);
            response.put("message", "Not logged in");
            return response;
        }
        
        // Verify assessment belongs to user
        Assessment assessment = AssessmentDAO.getAssessmentById(assessmentId);
        if (assessment == null || assessment.getUserId() != userId) {
            response.put("success", false);
            response.put("message", "Invalid assessment");
            return response;
        }
        
        // Save response
        boolean saved = AssessmentService.saveAnswer(assessmentId, questionId, scaleValue);
        response.put("success", saved);
        
        return response;
    }
    
    // =====================================================
    // STEP 6: Complete Assessment & Calculate Score
    // =====================================================
    @PostMapping("/complete")
    public String completeAssessment(
            @RequestParam("assessmentId") int assessmentId,
            HttpSession session,
            Model model) {
        
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        // Verify assessment
        Assessment assessment = AssessmentDAO.getAssessmentById(assessmentId);
        if (assessment == null || assessment.getUserId() != userId) {
            return "redirect:/assessment/select";
        }
        
        // Get assessment type
        AssessmentType type = AssessmentTypeDAO.getAssessmentTypeById(assessment.getAssessmentTypeId());
        
        // Calculate score & check for crisis
        ScoringService.ScoringResult result = ScoringService.calculateResult(
            assessmentId, 
            type.getCode(),
            assessment.getAssessmentTypeId()
        );
        
        // Update assessment dengan score & risk level
        AssessmentDAO.updateAssessmentScore(assessmentId, result.score, result.riskLevel);
        
        // CRISIS DETECTION: If crisis triggered, redirect to crisis page
        if (result.triggerCrisis) {
            // Log crisis alert
            System.out.println("🚨 CRISIS DETECTED for assessment " + assessmentId);
            
            // Save to risk_alerts table (optional)
            // RiskAlertDAO.createAlert(assessmentId, userId, "SUICIDAL_IDEATION", "CRITICAL");
            
            // Redirect to crisis intervention page
            return "redirect:/assessment/crisis?assessmentId=" + assessmentId;
        }
        
        // Normal flow: redirect to results
        return "redirect:/assessment/results?assessmentId=" + assessmentId;
    }
    
    // =====================================================
    // STEP 7: Show Results
    // =====================================================
    @GetMapping("/results")
    public String showResults(
            @RequestParam("assessmentId") int assessmentId,
            HttpSession session,
            Model model) {
        
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        // Get assessment
        Assessment assessment = AssessmentDAO.getAssessmentById(assessmentId);
        if (assessment == null || assessment.getUserId() != userId) {
            return "redirect:/assessment/select";
        }
        
        // Get assessment type
        AssessmentType type = AssessmentTypeDAO.getAssessmentTypeById(assessment.getAssessmentTypeId());
        
        // Get interpretation & recommendations
        String interpretation = getInterpretation(type.getCode(), assessment.getTotalScore(), assessment.getRiskLevel());
        List<String> recommendations = getRecommendations(type.getCode(), assessment.getRiskLevel());
        
        model.addAttribute("assessment", assessment);
        model.addAttribute("assessmentType", type);
        model.addAttribute("interpretation", interpretation);
        model.addAttribute("recommendations", recommendations);
        
        return "assessment-results";
    }
    
    // =====================================================
    // STEP 8: Crisis Intervention Page
    // =====================================================
    @GetMapping("/crisis")
    public String showCrisis(
            @RequestParam("assessmentId") int assessmentId,
            HttpSession session,
            Model model) {
        
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            return "redirect:/login";
        }
        
        // Verify assessment
        Assessment assessment = AssessmentDAO.getAssessmentById(assessmentId);
        if (assessment == null || assessment.getUserId() != userId) {
            return "redirect:/assessment/select";
        }
        
        model.addAttribute("assessmentId", assessmentId);
        return "crisis-intervention";
    }
    
    // =====================================================
    // HELPER METHODS
    // =====================================================
    
    private String getInterpretation(String code, double score, String riskLevel) {
        if ("PHQ-9".equals(code)) {
            if (score <= 4) return "Minimal depression";
            if (score <= 9) return "Mild depression";
            if (score <= 14) return "Moderate depression";
            if (score <= 19) return "Moderately severe depression";
            return "Severe depression";
        } else if ("GAD-7".equals(code)) {
            if (score <= 4) return "Minimal anxiety";
            if (score <= 9) return "Mild anxiety";
            if (score <= 14) return "Moderate anxiety";
            return "Severe anxiety";
        }
        return "Assessment completed";
    }
    
    private List<String> getRecommendations(String code, String riskLevel) {
        List<String> recs = new java.util.ArrayList<>();
        
        if ("HIGH".equals(riskLevel) || "CRITICAL".equals(riskLevel)) {
            recs.add("Schedule an appointment with a mental health professional immediately");
            recs.add("Contact your primary care physician");
            recs.add("If experiencing thoughts of self-harm, call emergency services");
        } else if ("MODERATE".equals(riskLevel)) {
            recs.add("Consider scheduling a consultation with a counselor");
            recs.add("Practice stress management techniques");
            recs.add("Maintain regular sleep and exercise routines");
        } else {
            recs.add("Continue monitoring your mental health");
            recs.add("Maintain healthy lifestyle habits");
            recs.add("Reach out to support groups if needed");
        }
        
        recs.add("Use EmotiCare's learning modules for self-help strategies");
        return recs;
    }
}
