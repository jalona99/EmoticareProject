package com.emoticare.dao;

import com.emoticare.model.ChatMessage;
import com.emoticare.model.ChatSession;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ChatDAO {
    private static final Logger logger = LoggerFactory.getLogger(ChatDAO.class);

    public int createSession(ChatSession session) throws SQLException {
        String sql = "INSERT INTO chat_sessions (user_id, title, created_at) VALUES (?, ?, ?) RETURNING id";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, session.getUserId());
            pstmt.setString(2, session.getTitle());
            pstmt.setTimestamp(3, Timestamp.valueOf(session.getCreatedAt()));
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1;
    }

    public List<ChatSession> getSessionsByUserId(int userId) throws SQLException {
        List<ChatSession> sessions = new ArrayList<>();
        String sql = "SELECT * FROM chat_sessions WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ChatSession session = new ChatSession();
                    session.setId(rs.getInt("id"));
                    session.setUserId(rs.getInt("user_id"));
                    session.setTitle(rs.getString("title"));
                    session.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    sessions.add(session);
                }
            }
        }
        return sessions;
    }

    public void deleteSession(int sessionId) throws SQLException {
        String sql = "DELETE FROM chat_sessions WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, sessionId);
            pstmt.executeUpdate();
        }
    }

    public void saveMessage(ChatMessage message) throws SQLException {
        String sql = "INSERT INTO chat_messages (session_id, sender, content, created_at) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, message.getSessionId());
            pstmt.setString(2, message.getSender());
            pstmt.setString(3, message.getContent());
            pstmt.setTimestamp(4, Timestamp.valueOf(message.getCreatedAt()));
            pstmt.executeUpdate();
        }
    }

    public List<ChatMessage> getMessagesBySessionId(int sessionId) throws SQLException {
        List<ChatMessage> messages = new ArrayList<>();
        String sql = "SELECT * FROM chat_messages WHERE session_id = ? ORDER BY created_at ASC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, sessionId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ChatMessage message = new ChatMessage();
                    message.setId(rs.getInt("id"));
                    message.setSessionId(rs.getInt("session_id"));
                    message.setSender(rs.getString("sender"));
                    message.setContent(rs.getString("content"));
                    message.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    messages.add(message);
                }
            }
        }
        return messages;
    }

    public void updateSessionTitle(int sessionId, String title) throws SQLException {
        String sql = "UPDATE chat_sessions SET title = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, title);
            pstmt.setInt(2, sessionId);
            pstmt.executeUpdate();
        }
    }
}
