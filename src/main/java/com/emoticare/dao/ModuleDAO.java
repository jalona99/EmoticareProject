package com.emoticare.dao;

import com.emoticare.model.Module;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ModuleDAO {
    private static final Logger logger = LoggerFactory.getLogger(ModuleDAO.class);

    public boolean createModule(Module module) throws SQLException {
        String sql = "INSERT INTO modules (title, description, content_url, created_at, updated_at) " +
                "VALUES (?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING id";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, module.getTitle());
            pstmt.setString(2, module.getDescription());
            pstmt.setString(3, module.getContentUrl());

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    module.setId(rs.getInt("id"));
                    return true;
                }
            }
        }
        return false;
    }

    public boolean updateModule(Module module) throws SQLException {
        String sql = "UPDATE modules SET title = ?, description = ?, content_url = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, module.getTitle());
            pstmt.setString(2, module.getDescription());
            pstmt.setString(3, module.getContentUrl());
            pstmt.setInt(4, module.getId());

            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteModule(int id) throws SQLException {
        String sql = "DELETE FROM modules WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    public Module getModuleById(int id) throws SQLException {
        String sql = "SELECT * FROM modules WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToModule(rs);
                }
            }
        }
        return null;
    }

    public List<Module> getAllModules() throws SQLException {
        List<Module> modules = new ArrayList<>();
        String sql = "SELECT * FROM modules ORDER BY id ASC";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                modules.add(mapRowToModule(rs));
            }
        }
        return modules;
    }

    private Module mapRowToModule(ResultSet rs) throws SQLException {
        Module module = new Module();
        module.setId(rs.getInt("id"));
        module.setTitle(rs.getString("title"));
        module.setDescription(rs.getString("description"));
        module.setContentUrl(rs.getString("content_url"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null)
            module.setCreatedAt(createdAt.toLocalDateTime());

        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null)
            module.setUpdatedAt(updatedAt.toLocalDateTime());

        return module;
    }
}
