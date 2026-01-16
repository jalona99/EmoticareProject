package com.emoticare.service;

import com.emoticare.dao.UserDAO;
import com.emoticare.dao.RoleDAO;
import com.emoticare.model.User;
import com.emoticare.model.Role;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.SQLException;
import java.util.*;
import java.util.regex.Pattern;

@Service
public class UserService {

    private static final Logger logger = LoggerFactory.getLogger(UserService.class);

    // Email pattern untuk institusi (bisa disesuaikan)
    private static final Pattern INSTITUTION_EMAIL_PATTERN =
            Pattern.compile("^[a-zA-Z0-9._%+-]+@graduate\\.utm\\.my$");

    @Autowired
    private PasswordEncoder passwordEncoder;

    private final UserDAO userDAO = new UserDAO();
    private final RoleDAO roleDAO = new RoleDAO();

    /**
     * Register user baru
     * Validasi dan hash password sebelum menyimpan
     */
    public Map<String, String> registerUser(User user) {
        Map<String, String> result = new HashMap<>();

        try {
            // 1. Validasi password confirmation
            if (!user.getPassword().equals(user.getConfirmPassword())) {
                result.put("error", "Password and confirmation do not match.");
                logger.warn("Password confirmation mismatch for: {}", user.getUsername());
                return result;
            }

            // 2. Validasi email domain institusi
            if (!INSTITUTION_EMAIL_PATTERN.matcher(user.getEmail()).matches()) {
                result.put("error", "Use your graduate UTM email (example: name@graduate.utm.my).");
                logger.warn("Invalid email domain: {}", user.getEmail());
                return result;
            }

            // 3. Check email sudah ada
            if (userDAO.emailExists(user.getEmail())) {
                result.put("error", "Email is already registered.");
                logger.warn("Email already exists: {}", user.getEmail());
                return result;
            }

            // 4. Check username sudah ada
            if (userDAO.usernameExists(user.getUsername())) {
                result.put("error", "Username is already taken.");
                logger.warn("Username already exists: {}", user.getUsername());
                return result;
            }

            // 5. Hash password dengan BCrypt
            String hashedPassword = passwordEncoder.encode(user.getPassword());
            user.setPassword(hashedPassword);

            // 6. Simpan ke database
            if (userDAO.createUser(user)) {
                result.put("success", "Registration successful! Please log in.");
                logger.info("User registered successfully: {}", user.getUsername());
            } else {
                result.put("error", "Failed to save data. Please try again.");
                logger.error("Failed to save user: {}", user.getUsername());
            }

        } catch (SQLException e) {
            result.put("error", "Database error: " + e.getMessage());
            logger.error("Database error during registration", e);
        } catch (Exception e) {
            result.put("error", "A system error occurred.");
            logger.error("Unexpected error during registration", e);
        }

        return result;
    }

    /**
     * Get semua roles untuk dropdown form
     */
    public List<Role> getAllRoles() throws SQLException {
        return roleDAO.getAllRoles();
    }

    /**
     * Validate user credentials (untuk login)
     */
    public boolean validateCredentials(String username, String rawPassword) {
        try {
            User user = userDAO.getUserByUsername(username);
            if (user == null) {
                logger.warn("Login failed: User {} not found", username);
                return false;
            }

            // Membandingkan password input (raw) dengan hash di database
            return passwordEncoder.matches(rawPassword, user.getPassword());
        } catch (SQLException e) {
            logger.error("Database error during validation", e);
            return false;
        }
    }


    /* =========================================================
       Tambahan method untuk kebutuhan Admin
       ======================================================== */

    /**
     * Ambil semua user (untuk halaman Admin Manage Users)
     */
    public List<User> getAllUsers() {
        try {
            return userDAO.findAllUsers();
        } catch (SQLException e) {
            logger.error("Error fetching all users", e);
            return Collections.emptyList();
        }
    }

    /**
     * Ubah role user (misalnya dari student ke admin/faculty)
     */
    public void changeUserRole(int userId, int roleId) {
        try {
            userDAO.updateUserRole(userId, roleId);
            logger.info("Admin changed role of userId={} to roleId={}", userId, roleId);
        } catch (SQLException e) {
            logger.error("Error updating user role for userId=" + userId, e);
        }
    }

    /**
     * Set user aktif / nonaktif (suspend account)
     */
    public void setUserActive(int userId, boolean active) {
        try {
            userDAO.updateUserActive(userId, active);
            logger.info("Admin set userId={} active={}", userId, active);
        } catch (SQLException e) {
            logger.error("Error updating active flag for userId=" + userId, e);
        }
    }

    /**
     * Hitung total user (untuk dashboard admin)
     */
    public static int getTotalUsers() {
        try {
            return UserDAO.countTotalUsers();
        } catch (Exception e) {
            System.err.println("Error counting users: " + e.getMessage());
            return 0;
        }
    }

}
