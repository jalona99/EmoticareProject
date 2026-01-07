package com.emoticare.dao;

import com.emoticare.model.Assessment;
import com.emoticare.model.AssessmentResponse;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class AssessmentDAO {

    /**
     * Create Assessment Record - FIXED WITH DETAILED ERROR LOGGING
     */
    public static int createAssessment(Assessment assessment) {
        String sql = "INSERT INTO assessments (user_id, assessment_type_id, status, started_at) " +
                    "VALUES (?, ?, ?, ?) RETURNING id";
        
        Connection conn = null;
        try {
            // ✅ Step 1: Get database connection
            conn = DatabaseConnection.getConnection();
            
            if (conn == null) {
                System.err.println("❌ CRITICAL ERROR: Database connection is NULL");
                System.err.println("   This means DatabaseConnection.getConnection() failed");
                System.err.println("   Check: Database credentials, host, port, database name");
                return -1;
            }
            
            System.out.println("✅ Database connection obtained");
            
            // ✅ Step 2: Prepare statement
            PreparedStatement pstmt = conn.prepareStatement(sql);
            System.out.println("✅ Prepared statement created");
            
            // ✅ Step 3: Set parameters
            System.out.println("📝 Setting parameters:");
            System.out.println("   userId: " + assessment.getUserId());
            System.out.println("   assessmentTypeId: " + assessment.getAssessmentTypeId());
            System.out.println("   status: DRAFT");
            System.out.println("   startedAt: " + assessment.getStartedAt());
            
            pstmt.setInt(1, assessment.getUserId());
            pstmt.setInt(2, assessment.getAssessmentTypeId());
            pstmt.setString(3, "DRAFT");
            pstmt.setTimestamp(4, Timestamp.valueOf(assessment.getStartedAt()));
            
            // ✅ Step 4: Execute query
            System.out.println("🔄 Executing SQL query...");
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int id = rs.getInt("id");
                System.out.println("✅ SUCCESS: Assessment created with ID = " + id);
                pstmt.close();
                return id;
            } else {
                System.err.println("❌ ERROR: ResultSet is empty (no ID returned)");
                pstmt.close();
                return -1;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ SQL EXCEPTION CAUGHT:");
            System.err.println("   Error Code: " + e.getErrorCode());
            System.err.println("   SQL State: " + e.getSQLState());
            System.err.println("   Message: " + e.getMessage());
            System.err.println("   Full Stack Trace:");
            e.printStackTrace();
            
            // ✅ Analyze common errors
            String sqlState = e.getSQLState();
            if (sqlState != null) {
                if (sqlState.equals("42P01")) {
                    System.err.println("   → TABLE NOT FOUND: 'assessments' table doesn't exist");
                    System.err.println("   → Create the table with provided SQL script");
                } else if (sqlState.equals("42703")) {
                    System.err.println("   → COLUMN NOT FOUND: One of the columns doesn't exist");
                    System.err.println("   → Check table structure: user_id, assessment_type_id, status, started_at");
                } else if (sqlState.startsWith("23")) {
                    System.err.println("   → CONSTRAINT VIOLATION: Foreign key or unique constraint failed");
                    System.err.println("   → Check: user_id exists in users table");
                    System.err.println("   → Check: assessment_type_id exists in assessment_types table");
                } else if (sqlState.equals("08006")) {
                    System.err.println("   → CONNECTION FAILED: Can't connect to database");
                    System.err.println("   → Check: Database is running, host, port, credentials");
                }
            }
            
            return -1;
            
        } catch (Exception e) {
            System.err.println("❌ GENERAL EXCEPTION:");
            System.err.println("   " + e.getClass().getName());
            System.err.println("   " + e.getMessage());
            e.printStackTrace();
            return -1;
            
        } finally {
            // ✅ Close connection if needed
            try {
                if (conn != null && !conn.isClosed()) {
                    // Don't close here if using try-with-resources elsewhere
                    // conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // =====================================================
    // Get Assessment by ID
    // =====================================================
    public static Assessment getAssessmentById(int id) {
        String sql = "SELECT * FROM assessments WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToAssessment(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // =====================================================
    // Get Assessments by User
    // =====================================================
    public static List<Assessment> getAssessmentsByUserId(int userId) {
        String sql = "SELECT * FROM assessments WHERE user_id = ? ORDER BY started_at DESC";
        List<Assessment> assessments = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                assessments.add(mapResultSetToAssessment(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return assessments;
    }

    // =====================================================
    // Update Assessment Score
    // =====================================================
    public static boolean updateAssessmentScore(int assessmentId, double score, String riskLevel) {
        String sql = "UPDATE assessments SET total_score = ?, risk_level = ?, " +
                    "status = 'COMPLETED', completed_at = ?, updated_at = ? WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setDouble(1, score);
            pstmt.setString(2, riskLevel);
            pstmt.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            pstmt.setTimestamp(4, Timestamp.valueOf(LocalDateTime.now()));
            pstmt.setInt(5, assessmentId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // =====================================================
    // Helper: Map ResultSet to Assessment
    // =====================================================
    private static Assessment mapResultSetToAssessment(ResultSet rs) throws SQLException {
        Assessment assessment = new Assessment();
        assessment.setId(rs.getInt("id"));
        assessment.setUserId(rs.getInt("user_id"));
        assessment.setAssessmentTypeId(rs.getInt("assessment_type_id"));
        assessment.setStatus(rs.getString("status"));
        assessment.setTotalScore(rs.getDouble("total_score"));
        assessment.setRiskLevel(rs.getString("risk_level"));
        
        Timestamp startedAt = rs.getTimestamp("started_at");
        if (startedAt != null) {
            assessment.setStartedAt(startedAt.toLocalDateTime());
        }
        
        Timestamp completedAt = rs.getTimestamp("completed_at");
        if (completedAt != null) {
            assessment.setCompletedAt(completedAt.toLocalDateTime());
        }
        
        return assessment;
    }

    // =====================================================
// Get ALL Assessments (untuk admin melihat semua)
// =====================================================
public static List<Assessment> getAllAssessments() {
    String sql = "SELECT * FROM assessments ORDER BY started_at DESC";
    List<Assessment> list = new ArrayList<>();
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql);
         ResultSet rs = pstmt.executeQuery()) {

        while (rs.next()) {
            list.add(mapResultSetToAssessment(rs));
        }
    } catch (SQLException e) {
        System.err.println("Error fetching all assessments: " + e.getMessage());
        e.printStackTrace();
    }
    return list;
}

// =====================================================
// Get Assessments by Filter (status, type)
// =====================================================
public static List<Assessment> getAssessmentsByFilter(String status, Integer typeId) {
    StringBuilder sql = new StringBuilder("SELECT * FROM assessments WHERE 1=1");
    
    if (status != null && !status.isEmpty()) {
        sql.append(" AND status = '").append(status).append("'");
    }
    if (typeId != null) {
        sql.append(" AND assessment_type_id = ").append(typeId);
    }
    sql.append(" ORDER BY started_at DESC");
    
    List<Assessment> list = new ArrayList<>();
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql.toString());
         ResultSet rs = pstmt.executeQuery()) {

        while (rs.next()) {
            list.add(mapResultSetToAssessment(rs));
        }
    } catch (SQLException e) {
        System.err.println("Error in getAssessmentsByFilter: " + e.getMessage());
        e.printStackTrace();
    }
    return list;
}

// =====================================================
// Get Responses untuk Assessment
// =====================================================
public static List<AssessmentResponse> getResponsesByAssessmentId(int assessmentId) {
    String sql = "SELECT * FROM assessment_responses WHERE assessment_id = ? ORDER BY question_id";
    List<AssessmentResponse> responses = new ArrayList<>();
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        
        pstmt.setInt(1, assessmentId);
        ResultSet rs = pstmt.executeQuery();
        
        while (rs.next()) {
            AssessmentResponse resp = new AssessmentResponse();
            resp.setId(rs.getInt("id"));
            resp.setAssessmentId(rs.getInt("assessment_id"));
            resp.setQuestionId(rs.getInt("question_id"));
            resp.setScaleValue(rs.getInt("scale_value"));
            responses.add(resp);
        }
    } catch (SQLException e) {
        System.err.println("Error fetching responses: " + e.getMessage());
        e.printStackTrace();
    }
    return responses;
}

// =====================================================
// Get Assessment Detail dengan User & Type Info
// =====================================================
public static Map<String, Object> getAssessmentDetailWithInfo(int assessmentId) {
    Map<String, Object> detail = new HashMap<>();
    
    String sql = "SELECT a.*, u.username, u.email, at.name as type_name, at.code as type_code " +
                 "FROM assessments a " +
                 "LEFT JOIN users u ON a.user_id = u.id " +
                 "LEFT JOIN assessment_types at ON a.assessment_type_id = at.id " +
                 "WHERE a.id = ?";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql)) {
        
        pstmt.setInt(1, assessmentId);
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next()) {
            detail.put("id", rs.getInt("id"));
            detail.put("userId", rs.getInt("user_id"));
            detail.put("username", rs.getString("username"));
            detail.put("email", rs.getString("email"));
            detail.put("assessmentTypeId", rs.getInt("assessment_type_id"));
            detail.put("typeName", rs.getString("type_name"));
            detail.put("typeCode", rs.getString("type_code"));
            detail.put("status", rs.getString("status"));
            detail.put("totalScore", rs.getDouble("total_score"));
            detail.put("riskLevel", rs.getString("risk_level"));
            detail.put("startedAt", rs.getTimestamp("started_at"));
            detail.put("completedAt", rs.getTimestamp("completed_at"));
        }
    } catch (SQLException e) {
        System.err.println("Error fetching detail: " + e.getMessage());
        e.printStackTrace();
    }
    return detail;
}

// =====================================================
// Count Total Assessments
// =====================================================
public static int countTotalAssessments() {
    String sql = "SELECT COUNT(*) FROM assessments";
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql);
         ResultSet rs = pstmt.executeQuery()) {
        
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException e) {
        System.err.println("Error counting: " + e.getMessage());
        e.printStackTrace();
    }
    return 0;
}

// =====================================================
// Count by Risk Level
// =====================================================
public static Map<String, Integer> countAssessmentsByRiskLevel() {
    Map<String, Integer> riskCount = new HashMap<>();
    String sql = "SELECT COALESCE(risk_level, 'UNKNOWN') as risk_level, COUNT(*) as count " +
                 "FROM assessments " +
                 "WHERE status = 'COMPLETED' " +
                 "GROUP BY risk_level";
    
    try (Connection conn = DatabaseConnection.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(sql);
         ResultSet rs = pstmt.executeQuery()) {
        
        while (rs.next()) {
            riskCount.put(rs.getString("risk_level"), rs.getInt("count"));
        }
    } catch (SQLException e) {
        System.err.println("Error counting by risk: " + e.getMessage());
        e.printStackTrace();
    }
    return riskCount;
}


}