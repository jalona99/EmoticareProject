package com.emoticare.dao;

import com.emoticare.model.ChatRiskAlert;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ChatRiskAlertDAO {

    public int createAlert(int userId, int sessionId, String trigger) throws SQLException {
        String sql = "INSERT INTO chat_risk_alerts (user_id, session_id, trigger, created_at, acknowledged) " +
                     "VALUES (?, ?, ?, CURRENT_TIMESTAMP, false) RETURNING id";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            pstmt.setInt(2, sessionId);
            pstmt.setString(3, trigger);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    public List<ChatRiskAlert> getRecentAlerts(int limit) throws SQLException {
        List<ChatRiskAlert> alerts = new ArrayList<>();
        String sql = "SELECT a.id, a.user_id, a.session_id, a.trigger, a.created_at, a.acknowledged, " +
                     "u.username, u.email " +
                     "FROM chat_risk_alerts a " +
                     "JOIN users u ON a.user_id = u.id " +
                     "ORDER BY a.created_at DESC " +
                     "LIMIT ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, limit);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ChatRiskAlert alert = new ChatRiskAlert();
                    alert.setId(rs.getInt("id"));
                    alert.setUserId(rs.getInt("user_id"));
                    int sessionId = rs.getInt("session_id");
                    alert.setSessionId(rs.wasNull() ? null : sessionId);
                    alert.setTrigger(rs.getString("trigger"));
                    alert.setAcknowledged(rs.getBoolean("acknowledged"));
                    alert.setUsername(rs.getString("username"));
                    alert.setEmail(rs.getString("email"));
                    Timestamp createdAt = rs.getTimestamp("created_at");
                    if (createdAt != null) {
                        alert.setCreatedAt(createdAt.toLocalDateTime());
                    }
                    alerts.add(alert);
                }
            }
        }
        return alerts;
    }

    public boolean acknowledgeAlert(int id) throws SQLException {
        String sql = "UPDATE chat_risk_alerts SET acknowledged = true, acknowledged_at = CURRENT_TIMESTAMP " +
                     "WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }
}
