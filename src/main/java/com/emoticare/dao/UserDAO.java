package com.emoticare.dao;

import com.emoticare.model.User;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * User Data Access Object - PostgreSQL 15 Version
 */
public class UserDAO {

    private static final Logger logger = LoggerFactory.getLogger(UserDAO.class);

    /**
     * Simpan user baru ke database
     * @param user User object dengan password yang sudah di-hash BCrypt
     * @return true jika berhasil, false jika gagal
     * @throws SQLException jika ada error database
     */
    public boolean createUser(User user) throws SQLException {
        // PostgreSQL RETURNING clause untuk mendapatkan generated ID
        String sql = "INSERT INTO users (username, email, password, role_id, is_active, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) " +
                     "RETURNING id";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPassword()); // Already BCrypt hashed
            pstmt.setInt(4, user.getRoleId());

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int userId = rs.getInt("id");
                    user.setId(userId);
                    logger.info("User created successfully with ID: {}", userId);
                    return true;
                }
            }

        } catch (SQLException e) {
            // PostgreSQL error codes (SQLState)
            // 23505 = unique_violation (duplicate key)
            if (e.getSQLState() != null && e.getSQLState().equals("23505")) {
                logger.warn("Duplicate user: {} or {}", user.getUsername(), user.getEmail());
            } else {
                logger.error("Database error creating user", e);
            }
            throw e;
        }

        return false;
    }

    /**
     * Check apakah email sudah terdaftar
     */
    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }

        return false;
    }

    /**
     * Check apakah username sudah terdaftar
     */
    public boolean usernameExists(String username) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }

        return false;
    }

    /**
     * Get user by email
     */
    public User getUserByEmail(String email) throws SQLException {
        String sql = "SELECT id, username, email, password, role_id, is_active, created_at, updated_at " +
                     "FROM users WHERE email = ? AND is_active = true";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, email);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToUser(rs);
                }
            }
        }

        return null;
    }

    /**
     * Get user by username
     */
    public User getUserByUsername(String username) throws SQLException {
        String sql = "SELECT id, username, email, password, role_id, is_active, created_at, updated_at " +
                     "FROM users WHERE username = ? AND is_active = true";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, username);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToUser(rs);
                }
            }
        }

        return null;
    }

    // ============================================================
    //  Tambahan untuk Admin
    // ============================================================

    /**
     * Ambil semua user (untuk halaman Manage Users admin)
     */
    public List<User> findAllUsers() throws SQLException {
        String sql = "SELECT id, username, email, password, role_id, is_active, created_at, updated_at " +
                     "FROM users ORDER BY id ASC";
        List<User> users = new ArrayList<>();

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                users.add(mapRowToUser(rs));
            }
        }

        return users;
    }

    /**
     * Update role user (misal dari student → admin)
     */
    public void updateUserRole(int userId, int roleId) throws SQLException {
        String sql = "UPDATE users SET role_id = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, roleId);
            pstmt.setInt(2, userId);
            int rows = pstmt.executeUpdate();
            logger.info("Updated role for userId={} to roleId={}, rowsAffected={}", userId, roleId, rows);
        }
    }

    /**
     * Aktif / nonaktifkan user (suspend / unsuspend)
     */
    public void updateUserActive(int userId, boolean active) throws SQLException {
        String sql = "UPDATE users SET is_active = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setBoolean(1, active);
            pstmt.setInt(2, userId);
            int rows = pstmt.executeUpdate();
            logger.info("Updated active flag for userId={} to {}, rowsAffected={}", userId, active, rows);
        }
    }

    /**
     * Hitung total user
     */
    public static int countTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting users: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // ============================================================
    //  Helper internal
    // ============================================================

    private User mapRowToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setRoleId(rs.getInt("role_id"));
        user.setActive(rs.getBoolean("is_active"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null) {
            user.setCreatedAt(createdAt.toLocalDateTime());
        }

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null) {
            user.setUpdatedAt(updatedAt.toLocalDateTime());
        }

        return user;
    }
}
