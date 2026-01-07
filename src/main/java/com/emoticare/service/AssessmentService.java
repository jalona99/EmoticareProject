package com.emoticare.service;

import com.emoticare.dao.*;
import com.emoticare.model.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;


public class AssessmentService {

    public static int startAssessment(int userId, int assessmentTypeId) {
        Assessment assessment = new Assessment();
        assessment.setUserId(userId);
        assessment.setAssessmentTypeId(assessmentTypeId);
        assessment.setStatus("IN_PROGRESS");
        assessment.setStartedAt(LocalDateTime.now());
        
        int assessmentId = AssessmentDAO.createAssessment(assessment);
        
        if (assessmentId > 0) {
            System.out.println("✅ Assessment created: ID=" + assessmentId + ", Type=" + assessmentTypeId);
        } else {
            System.err.println("❌ Failed to create assessment for user " + userId);
        }
        
        return assessmentId;
    }
    
    public static boolean saveAnswer(int assessmentId, int questionId, int scaleValue) {
        if (scaleValue < 0 || scaleValue > 4) {
            System.err.println("❌ Invalid scale value: " + scaleValue);
            return false;
        }
        
        AssessmentResponse response = new AssessmentResponse();
        response.setAssessmentId(assessmentId);
        response.setQuestionId(questionId);
        response.setScaleValue(scaleValue);
        response.setRespondedAt(LocalDateTime.now());
        
        AssessmentResponse existing = ResponseDAO.getResponse(assessmentId, questionId);
        
        boolean success;
        
        if (existing != null) {
            success = ResponseDAO.updateResponse(assessmentId, questionId, scaleValue);
            if (success) {
                System.out.println("✅ Updated answer: Q" + questionId + " = " + scaleValue);
            }
        } else {
            success = ResponseDAO.saveResponse(response);
            if (success) {
                System.out.println("✅ Saved answer: Q" + questionId + " = " + scaleValue);
            }
        }
        
        return success;
    }
    
    public static ScoringService.ScoringResult completeAssessment(
            int assessmentId,
            String typeCode,
            int assessmentTypeId) {
        
        System.out.println("📊 Calculating score for assessment " + assessmentId + " (Type: " + typeCode + ")");
        
        ScoringService.ScoringResult result = ScoringService.calculateResult(
            assessmentId,
            typeCode,
            assessmentTypeId
        );
        
        System.out.println("📊 Score: " + result.score);
        System.out.println("📊 Risk Level: " + result.riskLevel);
        System.out.println("🚨 Crisis Detected: " + result.triggerCrisis);
        
        return result;
    }
    
    public static Assessment getAssessment(int assessmentId) {
        return AssessmentDAO.getAssessmentById(assessmentId);
    }
    
    public static boolean isComplete(int assessmentId, int totalQuestions) {
        int answeredCount = ResponseDAO.getResponsesByAssessmentId(assessmentId).size();
        return answeredCount >= totalQuestions;
    }
    
    public static List<AssessmentType> getAllAssessmentTypes() {
        return AssessmentTypeDAO.getAllAssessmentTypes();
    }

    public static List<Assessment> getAllAssessments() {
    try {
        return AssessmentDAO.getAllAssessments();
    } catch (Exception e) {
        System.err.println("Error in getAllAssessments: " + e.getMessage());
        return new ArrayList<>();
    }
}

public static List<Assessment> getAssessmentsByFilter(String status, Integer typeId) {
    try {
        return AssessmentDAO.getAssessmentsByFilter(status, typeId);
    } catch (Exception e) {
        System.err.println("Error in getAssessmentsByFilter: " + e.getMessage());
        return new ArrayList<>();
    }
}

public static List<AssessmentResponse> getResponsesForAssessment(int assessmentId) {
    try {
        return AssessmentDAO.getResponsesByAssessmentId(assessmentId);
    } catch (Exception e) {
        System.err.println("Error fetching responses: " + e.getMessage());
        return new ArrayList<>();
    }
}

public static Map<String, Object> getAssessmentDetail(int assessmentId) {
    try {
        return AssessmentDAO.getAssessmentDetailWithInfo(assessmentId);
    } catch (Exception e) {
        System.err.println("Error fetching detail: " + e.getMessage());
        return new HashMap<>();
    }
}

public static int getTotalAssessments() {
    try {
        return AssessmentDAO.countTotalAssessments();
    } catch (Exception e) {
        System.err.println("Error counting: " + e.getMessage());
        return 0;
    }
}

public static Map<String, Integer> getAssessmentRiskLevelStats() {
    try {
        return AssessmentDAO.countAssessmentsByRiskLevel();
    } catch (Exception e) {
        System.err.println("Error getting stats: " + e.getMessage());
        return new HashMap<>();
    }
}


}
