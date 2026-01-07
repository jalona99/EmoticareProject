package com.emoticare.model;

import java.time.LocalDateTime;

public class AssessmentResponse {
    private int id;
    private int assessmentId;
    private int questionId;
    private int scaleValue;
    private LocalDateTime respondedAt;
    
    public AssessmentResponse() {}
    
    public AssessmentResponse(int assessmentId, int questionId, int scaleValue) {
        this.assessmentId = assessmentId;
        this.questionId = questionId;
        this.scaleValue = scaleValue;
        this.respondedAt = LocalDateTime.now();
    }
    
    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getAssessmentId() { return assessmentId; }
    public void setAssessmentId(int assessmentId) { this.assessmentId = assessmentId; }
    
    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    
    public int getScaleValue() { return scaleValue; }
    public void setScaleValue(int scaleValue) { this.scaleValue = scaleValue; }
    
    public LocalDateTime getRespondedAt() { return respondedAt; }
    public void setRespondedAt(LocalDateTime respondedAt) { this.respondedAt = respondedAt; }
}
