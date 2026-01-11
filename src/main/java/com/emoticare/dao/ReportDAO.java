package com.emoticare.dao;

import com.emoticare.model.Badge;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO {
    private static final Logger logger = LoggerFactory.getLogger(ReportDAO.class);

    // Module Completion Stats: Map<ModuleTitle, Count>
    public Map<String, Integer> getModuleCompletionStats() throws SQLException {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT m.title, COUNT(up.id) as completion_count " +
                "FROM modules m " +
                "LEFT JOIN user_progress up ON m.id = up.module_id AND up.status = 'COMPLETED' " +
                "GROUP BY m.id, m.title";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                stats.put(rs.getString("title"), rs.getInt("completion_count"));
            }
        }
        return stats;
    }

    // Quiz Scores: List of Maps (User, Module, Score)
    public List<Map<String, Object>> getAllQuizScores() throws SQLException {
        List<Map<String, Object>> scores = new ArrayList<>();
        String sql = "SELECT u.username, m.title, up.quiz_score " +
                "FROM user_progress up " +
                "JOIN users u ON up.user_id = u.id " +
                "JOIN modules m ON up.module_id = m.id " +
                "WHERE up.quiz_score IS NOT NULL " +
                "ORDER BY up.completed_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("username", rs.getString("username"));
                row.put("module", rs.getString("title"));
                row.put("score", rs.getInt("quiz_score"));
                scores.add(row);
            }
        }
        return scores;
    }

    // Badges Earned: List of Maps (User, Badge, Date)
    public List<Map<String, Object>> getAllBadgesEarned() throws SQLException {
        List<Map<String, Object>> badges = new ArrayList<>();
        String sql = "SELECT u.username, b.name as badge_name, ub.earned_at " +
                "FROM user_badges ub " +
                "JOIN users u ON ub.user_id = u.id " +
                "JOIN badges b ON ub.badge_id = b.id " +
                "ORDER BY ub.earned_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("username", rs.getString("username"));
                row.put("badge", rs.getString("badge_name"));
                row.put("earnedAt", rs.getTimestamp("earned_at").toLocalDateTime());
                badges.add(row);
            }
        }
        return badges;
    }

    // Forum Stats: Map of Counts
    public Map<String, Integer> getForumStats() throws SQLException {
        Map<String, Integer> stats = new HashMap<>();
        try (Connection conn = DatabaseConnection.getConnection()) {
            // Posts
            try (Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM forum_posts")) {
                if (rs.next())
                    stats.put("total_posts", rs.getInt(1));
            }
            // Comments
            try (Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM forum_comments")) {
                if (rs.next())
                    stats.put("total_comments", rs.getInt(1));
            }
            // Likes
            try (Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM forum_likes")) {
                if (rs.next())
                    stats.put("total_likes", rs.getInt(1));
            }
        }
        return stats;
    }
}
