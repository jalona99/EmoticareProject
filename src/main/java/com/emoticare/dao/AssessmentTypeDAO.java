package com.emoticare.dao;

import com.emoticare.model.AssessmentType;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AssessmentTypeDAO {
    
    public static List<AssessmentType> getAllAssessmentTypes() {
        String sql = "SELECT * FROM assessment_types ORDER BY id";
        List<AssessmentType> types = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                AssessmentType type = new AssessmentType();
                type.setId(rs.getInt("id"));
                type.setName(rs.getString("name"));
                type.setDescription(rs.getString("description"));
                type.setCode(rs.getString("code"));
                type.setTotalQuestions(rs.getInt("total_questions"));
                type.setMinScore(rs.getDouble("min_score"));
                type.setMaxScore(rs.getDouble("max_score"));
                
                types.add(type);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return types;
    }
    
    public static AssessmentType getAssessmentTypeById(int id) {
        String sql = "SELECT * FROM assessment_types WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                AssessmentType type = new AssessmentType();
                type.setId(rs.getInt("id"));
                type.setName(rs.getString("name"));
                type.setDescription(rs.getString("description"));
                type.setCode(rs.getString("code"));
                type.setTotalQuestions(rs.getInt("total_questions"));
                
                return type;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
