package com.emoticare.model;

import java.time.LocalDateTime;

public class Assessment {
    private int id;
    private int userId;
    private int assessmentTypeId;
    private String status; // DRAFT, COMPLETED, ABANDONED
    private double totalScore;
    private String riskLevel; // LOW, MODERATE, HIGH, CRITICAL
    private LocalDateTime startedAt;
    private LocalDateTime completedAt;
    private LocalDateTime updatedAt;
    
    // Constructors
    public Assessment() {}
    
    public Assessment(int userId, int assessmentTypeId) {
        this.userId = userId;
        this.assessmentTypeId = assessmentTypeId;
        this.status = "DRAFT";
        this.startedAt = LocalDateTime.now();
    }
    
    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getAssessmentTypeId() { return assessmentTypeId; }
    public void setAssessmentTypeId(int assessmentTypeId) { this.assessmentTypeId = assessmentTypeId; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public double getTotalScore() { return totalScore; }
    public void setTotalScore(double totalScore) { this.totalScore = totalScore; }
    
    public String getRiskLevel() { return riskLevel; }
    public void setRiskLevel(String riskLevel) { this.riskLevel = riskLevel; }
    
    public LocalDateTime getStartedAt() { return startedAt; }
    public void setStartedAt(LocalDateTime startedAt) { this.startedAt = startedAt; }
    
    public LocalDateTime getCompletedAt() { return completedAt; }
    public void setCompletedAt(LocalDateTime completedAt) { this.completedAt = completedAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
