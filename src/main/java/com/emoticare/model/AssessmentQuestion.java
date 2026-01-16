package com.emoticare.model;

import java.util.Map;

public class AssessmentQuestion {
    private int id;
    private int assessmentTypeId;
    private String questionText;
    private int questionOrder;
    private String questionCode;
    private boolean reverseScored;
    private Map<Integer, String> scales;
    
    public AssessmentQuestion() {}
    
    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getAssessmentTypeId() { return assessmentTypeId; }
    public void setAssessmentTypeId(int assessmentTypeId) { this.assessmentTypeId = assessmentTypeId; }
    
    public String getQuestionText() { return questionText; }
    public void setQuestionText(String questionText) { this.questionText = questionText; }
    
    public int getQuestionOrder() { return questionOrder; }
    public void setQuestionOrder(int questionOrder) { this.questionOrder = questionOrder; }
    
    public String getQuestionCode() { return questionCode; }
    public void setQuestionCode(String questionCode) { this.questionCode = questionCode; }
    
    public boolean isReverseScored() { return reverseScored; }
    public void setReverseScored(boolean reverseScored) { this.reverseScored = reverseScored; }
    
    public Map<Integer, String> getScales() { return scales; }
    public void setScales(Map<Integer, String> scales) { this.scales = scales; }
}
