package com.emoticare.dao;

import com.emoticare.model.AssessmentResponse;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ResponseDAO {
    
    public static boolean saveResponse(AssessmentResponse response) {
        String sql = "INSERT INTO assessment_responses (assessment_id, question_id, scale_value, responded_at) " +
                     "VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, response.getAssessmentId());
            pstmt.setInt(2, response.getQuestionId());
            pstmt.setInt(3, response.getScaleValue());
            pstmt.setTimestamp(4, java.sql.Timestamp.from(
                response.getRespondedAt().atZone(java.time.ZoneId.systemDefault()).toInstant()
            ));
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public static List<AssessmentResponse> getResponsesByAssessmentId(int assessmentId) {
        String sql = "SELECT * FROM assessment_responses WHERE assessment_id = ? " +
                     "ORDER BY responded_at ASC";
        
        List<AssessmentResponse> responses = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, assessmentId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                AssessmentResponse response = new AssessmentResponse();
                response.setId(rs.getInt("id"));
                response.setAssessmentId(rs.getInt("assessment_id"));
                response.setQuestionId(rs.getInt("question_id"));
                response.setScaleValue(rs.getInt("scale_value"));
                responses.add(response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return responses;
    }
    
    public static AssessmentResponse getResponse(int assessmentId, int questionId) {
        String sql = "SELECT * FROM assessment_responses WHERE assessment_id = ? AND question_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, assessmentId);
            pstmt.setInt(2, questionId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                AssessmentResponse response = new AssessmentResponse();
                response.setId(rs.getInt("id"));
                response.setAssessmentId(rs.getInt("assessment_id"));
                response.setQuestionId(rs.getInt("question_id"));
                response.setScaleValue(rs.getInt("scale_value"));
                return response;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public static boolean updateResponse(int assessmentId, int questionId, int scaleValue) {
        String sql = "UPDATE assessment_responses SET scale_value = ? WHERE assessment_id = ? AND question_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, scaleValue);
            pstmt.setInt(2, assessmentId);
            pstmt.setInt(3, questionId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    public static int getSpecificAnswer(int assessmentId, int questionOrder) {
        String sql = "SELECT ar.scale_value FROM assessment_responses ar " +
                     "JOIN assessment_questions aq ON ar.question_id = aq.id " +
                     "WHERE ar.assessment_id = ? AND aq.question_order = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, assessmentId);
            pstmt.setInt(2, questionOrder);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("scale_value");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return -1;
    }
}
