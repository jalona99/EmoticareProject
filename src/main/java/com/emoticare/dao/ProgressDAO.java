package com.emoticare.dao;

import com.emoticare.model.Badge;
import com.emoticare.model.UserProgress;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProgressDAO {
    private static final Logger logger = LoggerFactory.getLogger(ProgressDAO.class);

    // --- Progress Tracking ---

    public UserProgress getUserProgress(int userId, int moduleId) throws SQLException {
        String sql = "SELECT * FROM user_progress WHERE user_id = ? AND module_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            pstmt.setInt(2, moduleId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    UserProgress up = new UserProgress();
                    up.setId(rs.getInt("id"));
                    up.setUserId(rs.getInt("user_id"));
                    up.setModuleId(rs.getInt("module_id"));
                    up.setStatus(rs.getString("status"));
                    up.setQuizScore(rs.getInt("quiz_score"));
                    if (rs.wasNull())
                        up.setQuizScore(null);

                    Timestamp completedAt = rs.getTimestamp("completed_at");
                    if (completedAt != null)
                        up.setCompletedAt(completedAt.toLocalDateTime());

                    return up;
                }
            }
        }
        return null;
    }

    public void upsertProgress(UserProgress progress) throws SQLException {
        // Check exist
        UserProgress existing = getUserProgress(progress.getUserId(), progress.getModuleId());

        if (existing == null) {
            String sql = "INSERT INTO user_progress (user_id, module_id, status, quiz_score, completed_at, created_at) "
                    +
                    "VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
            try (Connection conn = DatabaseConnection.getConnection();
                    PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, progress.getUserId());
                pstmt.setInt(2, progress.getModuleId());
                pstmt.setString(3, progress.getStatus());
                if (progress.getQuizScore() != null)
                    pstmt.setInt(4, progress.getQuizScore());
                else
                    pstmt.setNull(4, java.sql.Types.INTEGER);

                if (progress.getCompletedAt() != null)
                    pstmt.setTimestamp(5, Timestamp.valueOf(progress.getCompletedAt()));
                else
                    pstmt.setNull(5, java.sql.Types.TIMESTAMP);

                pstmt.executeUpdate();
            }
        } else {
            String sql = "UPDATE user_progress SET status = ?, quiz_score = ?, completed_at = ? WHERE id = ?";
            try (Connection conn = DatabaseConnection.getConnection();
                    PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, progress.getStatus());
                if (progress.getQuizScore() != null)
                    pstmt.setInt(2, progress.getQuizScore());
                else
                    pstmt.setNull(2, java.sql.Types.INTEGER);

                if (progress.getCompletedAt() != null)
                    pstmt.setTimestamp(3, Timestamp.valueOf(progress.getCompletedAt()));
                else
                    pstmt.setNull(3, java.sql.Types.TIMESTAMP);

                pstmt.setInt(4, existing.getId());
                pstmt.executeUpdate();
            }
        }
    }

    // --- Badge Operations ---

    public List<Badge> getAllBadges() throws SQLException {
        List<Badge> badges = new ArrayList<>();
        String sql = "SELECT * FROM badges";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                badges.add(mapRowToBadge(rs));
            }
        }
        return badges;
    }

    public List<Badge> getUserBadges(int userId) throws SQLException {
        List<Badge> badges = new ArrayList<>();
        String sql = "SELECT b.* FROM badges b JOIN user_badges ub ON b.id = ub.badge_id WHERE ub.user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    badges.add(mapRowToBadge(rs));
                }
            }
        }
        return badges;
    }

    public boolean hasBadge(int userId, int badgeId) throws SQLException {
        String sql = "SELECT 1 FROM user_badges WHERE user_id = ? AND badge_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, badgeId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void awardBadge(int userId, int badgeId) throws SQLException {
        if (!hasBadge(userId, badgeId)) {
            String sql = "INSERT INTO user_badges (user_id, badge_id, earned_at) VALUES (?, ?, CURRENT_TIMESTAMP)";
            try (Connection conn = DatabaseConnection.getConnection();
                    PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, userId);
                pstmt.setInt(2, badgeId);
                pstmt.executeUpdate();
            }
        }
    }

    // --- Badge CRUD ---

    public boolean createBadge(Badge badge) throws SQLException {
        String sql = "INSERT INTO badges (name, description, icon_url, criteria_module_id) VALUES (?, ?, ?, ?) RETURNING id";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, badge.getName());
            pstmt.setString(2, badge.getDescription());
            pstmt.setString(3, badge.getIconUrl());
            if (badge.getCriteriaModuleId() != null)
                pstmt.setInt(4, badge.getCriteriaModuleId());
            else
                pstmt.setNull(4, java.sql.Types.INTEGER);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    badge.setId(rs.getInt("id"));
                    return true;
                }
            }
        }
        return false;
    }

    public boolean deleteBadge(int id) throws SQLException {
        String sql = "DELETE FROM badges WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    public Badge getBadgeById(int id) throws SQLException {
        String sql = "SELECT * FROM badges WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToBadge(rs);
                }
            }
        }
        return null;
    }

    private Badge mapRowToBadge(ResultSet rs) throws SQLException {
        Badge b = new Badge();
        b.setId(rs.getInt("id"));
        b.setName(rs.getString("name"));
        b.setDescription(rs.getString("description"));
        b.setIconUrl(rs.getString("icon_url"));

        int criteria = rs.getInt("criteria_module_id");
        if (rs.wasNull())
            b.setCriteriaModuleId(null);
        else
            b.setCriteriaModuleId(criteria);
        return b;
    }
}
