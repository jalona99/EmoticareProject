package com.emoticare.dao;

import com.emoticare.model.ProfessionalProfile;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ProfessionalDAO {
    private static final Logger logger = LoggerFactory.getLogger(ProfessionalDAO.class);

    public List<ProfessionalProfile> getAllProfessionals() throws SQLException {
        List<ProfessionalProfile> profiles = new ArrayList<>();
        String sql = "SELECT * FROM professional_profiles";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                ProfessionalProfile profile = new ProfessionalProfile();
                profile.setId(rs.getInt("id"));
                profile.setUserId(rs.getInt("user_id"));
                profile.setName(rs.getString("name"));
                profile.setCredentials(rs.getString("credentials"));
                profile.setSpecialty(rs.getString("specialty"));
                profile.setBio(rs.getString("bio"));
                profile.setCalendlyUrl(rs.getString("calendly_url"));
                profiles.add(profile);
            }
        }
        return profiles;
    }

    public ProfessionalProfile getById(int id) throws SQLException {
        String sql = "SELECT * FROM professional_profiles WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ProfessionalProfile profile = new ProfessionalProfile();
                    profile.setId(rs.getInt("id"));
                    profile.setUserId(rs.getInt("user_id"));
                    profile.setName(rs.getString("name"));
                    profile.setCredentials(rs.getString("credentials"));
                    profile.setSpecialty(rs.getString("specialty"));
                    profile.setBio(rs.getString("bio"));
                    profile.setCalendlyUrl(rs.getString("calendly_url"));
                    return profile;
                }
            }
        }
        return null;
    }


    public int createProfessionalProfile(ProfessionalProfile profile) throws SQLException {
        String sql = "INSERT INTO professional_profiles (name, credentials, specialty, bio, calendly_url) " +
                "VALUES (?, ?, ?, ?, ?) RETURNING id";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, profile.getName());
            pstmt.setString(2, profile.getCredentials());
            pstmt.setString(3, profile.getSpecialty());
            pstmt.setString(4, profile.getBio());
            pstmt.setString(5, profile.getCalendlyUrl());

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    int profileId = rs.getInt(1);
                    logger.info("Created professional profile with id={}", profileId);
                    return profileId;
                }
            }
        }
        return -1;
    }

    public boolean updateProfessionalProfile(ProfessionalProfile profile) throws SQLException {
        String sql = "UPDATE professional_profiles SET name = ?, credentials = ?, specialty = ?, bio = ?, " +
                "calendly_url = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, profile.getName());
            pstmt.setString(2, profile.getCredentials());
            pstmt.setString(3, profile.getSpecialty());
            pstmt.setString(4, profile.getBio());
            pstmt.setString(5, profile.getCalendlyUrl());
            pstmt.setInt(6, profile.getId());
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                logger.info("Updated professional profile id={}", profile.getId());
                return true;
            }
        }
        return false;
    }

    public boolean deleteProfessionalProfile(int id) throws SQLException {
        String sql = "DELETE FROM professional_profiles WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                logger.info("Deleted professional profile id={}", id);
                return true;
            }
        }
        return false;
    }
}
