package com.emoticare.dao;

import com.emoticare.model.AssessmentQuestion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;

public class QuestionDAO {
    
    public static List<AssessmentQuestion> getQuestionsByType(int assessmentTypeId) {
        String sql = "SELECT * FROM assessment_questions WHERE assessment_type_id = ? " +
                    "ORDER BY question_order ASC";
        List<AssessmentQuestion> questions = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, assessmentTypeId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                AssessmentQuestion question = new AssessmentQuestion();
                question.setId(rs.getInt("id"));
                question.setAssessmentTypeId(rs.getInt("assessment_type_id"));
                question.setQuestionText(rs.getString("question_text"));
                question.setQuestionOrder(rs.getInt("question_order"));
                question.setQuestionCode(rs.getString("question_code"));
                question.setReverseScored(rs.getBoolean("reverse_scored"));
                
                questions.add(question);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }
    
    public static Map<Integer, String> getScalesForQuestion(int questionId) {
        String sql = "SELECT scale_value, scale_label FROM question_scales " +
                    "WHERE assessment_question_id = ? ORDER BY scale_order ASC";
        Map<Integer, String> scales = new LinkedHashMap<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, questionId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                scales.put(rs.getInt("scale_value"), rs.getString("scale_label"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return scales;
    }
}
