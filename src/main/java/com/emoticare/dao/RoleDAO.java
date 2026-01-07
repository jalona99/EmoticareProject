package com.emoticare.dao;

import com.emoticare.model.Role;
import java.sql.*;
import java.util.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class RoleDAO {
    private static final Logger logger = LoggerFactory.getLogger(RoleDAO.class);

    /**
     * Get all available roles
     */
    public List<Role> getAllRoles() throws SQLException {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT id, name, description FROM roles WHERE 1=1 ORDER BY name";
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Role role = new Role(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("description")
                );
                roles.add(role);
            }
            logger.debug("Retrieved {} roles from database", roles.size());
        }
        return roles;
    }

    /**
     * Get role by ID
     */
    public Role getRoleById(Integer roleId) throws SQLException {
        String sql = "SELECT id, name, description FROM roles WHERE id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, roleId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new Role(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description")
                    );
                }
            }
        }
        return null;
    }
}
