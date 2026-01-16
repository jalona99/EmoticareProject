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
                
                // Load scales for this question
                question.setScales(getScalesForQuestion(question.getId()));
                
                questions.add(question);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }
    
    public static AssessmentQuestion getQuestionById(int id) {
        String sql = "SELECT * FROM assessment_questions WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                AssessmentQuestion q = new AssessmentQuestion();
                q.setId(rs.getInt("id"));
                q.setAssessmentTypeId(rs.getInt("assessment_type_id"));
                q.setQuestionText(rs.getString("question_text"));
                q.setQuestionOrder(rs.getInt("question_order"));
                q.setQuestionCode(rs.getString("question_code"));
                q.setReverseScored(rs.getBoolean("reverse_scored"));
                return q;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public static boolean createQuestion(AssessmentQuestion q) {
        String sql = "INSERT INTO assessment_questions (assessment_type_id, question_text, question_order, question_code, reverse_scored) " +
                    "VALUES (?, ?, ?, ?, ?) RETURNING id";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, q.getAssessmentTypeId());
            pstmt.setString(2, q.getQuestionText());
            pstmt.setInt(3, q.getQuestionOrder());
            pstmt.setString(4, q.getQuestionCode());
            pstmt.setBoolean(5, q.isReverseScored());
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                q.setId(rs.getInt(1));
                syncScales(q.getId(), q.getAssessmentTypeId());
                return true;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public static boolean updateQuestion(AssessmentQuestion q) {
        String sql = "UPDATE assessment_questions SET question_text = ?, question_order = ?, " +
                    "question_code = ?, reverse_scored = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, q.getQuestionText());
            pstmt.setInt(2, q.getQuestionOrder());
            pstmt.setString(3, q.getQuestionCode());
            pstmt.setBoolean(4, q.isReverseScored());
            pstmt.setInt(5, q.getId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public static boolean deleteQuestion(int id) {
        String sql = "DELETE FROM assessment_questions WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
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

    private static void syncScales(int questionId, int typeId) {
        // Copy scales from an existing question of the same type
        String sql = "INSERT INTO question_scales (assessment_question_id, scale_value, scale_label, scale_order) " +
                    "SELECT ?, scale_value, scale_label, scale_order FROM question_scales " +
                    "WHERE assessment_question_id = (SELECT id FROM assessment_questions WHERE assessment_type_id = ? AND id != ? LIMIT 1) " +
                    "ON CONFLICT DO NOTHING";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, questionId);
            pstmt.setInt(2, typeId);
            pstmt.setInt(3, questionId);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }
}
