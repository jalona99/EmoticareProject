package com.emoticare.service;

import com.emoticare.dao.*;
import com.emoticare.model.*;
import java.util.List;

public class ScoringService {
    
    public static class ScoringResult {
        public double score;
        public String riskLevel;
        public boolean triggerCrisis; // ✅ TAMBAHAN UNTUK CRISIS DETECTION
        
        public ScoringResult(double score, String riskLevel, boolean triggerCrisis) {
            this.score = score;
            this.riskLevel = riskLevel;
            this.triggerCrisis = triggerCrisis;
        }
    }
    
    // ✅ MAIN METHOD: Calculate with crisis detection
   public static ScoringResult calculateResult(int assessmentId, String typeCode, int assessmentTypeId) {
    if ("PHQ-9".equals(typeCode)) {
        return scorePHQ9(assessmentId);
    } else if ("GAD-7".equals(typeCode)) {
        return scoreGAD7(assessmentId);
    } else if ("PSS-10".equals(typeCode)) {
        return scorePSS10(assessmentId, assessmentTypeId);
    }
    
    return new ScoringResult(0, "UNKNOWN", false);
}
    
    // ✅ PHQ-9 Scoring (0-27) with SUICIDAL IDEATION check
    private static ScoringResult scorePHQ9(int assessmentId) {
        List<AssessmentResponse> responses = ResponseDAO.getResponsesByAssessmentId(assessmentId);
        double totalScore = 0;
        boolean triggerCrisis = false;
        
        for (AssessmentResponse response : responses) {
            totalScore += response.getScaleValue();
            
            // ✅ CRITICAL: Check question 9 (suicidal ideation)
            // If user answered > 0 pada pertanyaan nomor 9, TRIGGER CRISIS
            if (response.getQuestionId() == getQuestion9Id(assessmentId) && response.getScaleValue() > 0) {
                triggerCrisis = true;
            }
        }
        
        String riskLevel = getRiskLevelPHQ9(totalScore);
        
        // If score >= 20, also trigger crisis
        if (totalScore >= 20) {
            triggerCrisis = true;
        }
        
        return new ScoringResult(totalScore, riskLevel, triggerCrisis);
    }
    
    private static String getRiskLevelPHQ9(double score) {
        if (score <= 4) return "MINIMAL";
        if (score <= 9) return "MILD";
        if (score <= 14) return "MODERATE";
        if (score <= 19) return "MODERATELY_SEVERE";
        return "SEVERE";
    }
    
    // ✅ GAD-7 Scoring (0-21)
    private static ScoringResult scoreGAD7(int assessmentId) {
        List<AssessmentResponse> responses = ResponseDAO.getResponsesByAssessmentId(assessmentId);
        double totalScore = 0;
        
        for (AssessmentResponse response : responses) {
            totalScore += response.getScaleValue();
        }
        
        String riskLevel = getRiskLevelGAD7(totalScore);
        boolean triggerCrisis = (totalScore >= 15); // Severe anxiety
        
        return new ScoringResult(totalScore, riskLevel, triggerCrisis);
    }
    
    private static String getRiskLevelGAD7(double score) {
        if (score <= 4) return "MINIMAL";
        if (score <= 9) return "MILD";
        if (score <= 14) return "MODERATE";
        return "SEVERE";
    }
    
    // ✅ PSS-10 Scoring (0-40) with reverse scoring
    private static ScoringResult scorePSS10(int assessmentId, int assessmentTypeId) {
        List<AssessmentResponse> responses = ResponseDAO.getResponsesByAssessmentId(assessmentId);
        List<AssessmentQuestion> questions = QuestionDAO.getQuestionsByType(assessmentTypeId);
        
        double totalScore = 0;
        for (AssessmentResponse response : responses) {
            int scaleValue = response.getScaleValue();
            
            // Check if reverse scored
            for (AssessmentQuestion q : questions) {
                if (q.getId() == response.getQuestionId() && q.isReverseScored()) {
                    scaleValue = 4 - scaleValue; // Reverse
                    break;
                }
            }
            totalScore += scaleValue;
        }
        
        String riskLevel = getRiskLevelPSS10(totalScore);
        boolean triggerCrisis = (totalScore >= 27); // Very high stress
        
        return new ScoringResult(totalScore, riskLevel, triggerCrisis);
    }
    
    private static String getRiskLevelPSS10(double score) {
        if (score < 13) return "LOW";
        if (score < 27) return "MODERATE";
        return "HIGH";
    }
    
    // ✅ HELPER: Get question 9 ID (suicidal ideation) for PHQ-9
    private static int getQuestion9Id(int assessmentId) {
        Assessment assessment = AssessmentDAO.getAssessmentById(assessmentId);
        List<AssessmentQuestion> questions = QuestionDAO.getQuestionsByType(assessment.getAssessmentTypeId());
        
        // Pertanyaan nomor 9 adalah yang terakhir dalam PHQ-9
        if (questions.size() >= 9) {
            return questions.get(8).getId(); // Index 8 = question 9
        }
        return -1;
    }
}
