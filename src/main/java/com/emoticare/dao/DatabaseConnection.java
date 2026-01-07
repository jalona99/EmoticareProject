package com.emoticare.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * PostgreSQL 15 Database Connection Utility
 * Diverifikasi: 04-01-2026
 */
public class DatabaseConnection {
    private static final Logger logger = LoggerFactory.getLogger(DatabaseConnection.class);
    
    // ============================================
    // POSTGRESQL 15 CONNECTION PARAMETERS
    // ============================================
    // DRIVER: PostgreSQL JDBC Driver
    private static final String DRIVER = "org.postgresql.Driver";
    
    // URL: PostgreSQL connection string
    // Format: jdbc:postgresql://[host]:[port]/[database]
    private static final String URL = "jdbc:postgresql://localhost:5432/emoticare_db";
    
    // USER: Application user (bukan postgres superuser)
    private static final String USER = "emoticare_user";
    
    // PASSWORD: Secure password dari database setup
    private static final String PASSWORD = "SecurePassword123!";

    static {
        try {
            // Load PostgreSQL JDBC Driver
            Class.forName(DRIVER);
            logger.info("PostgreSQL JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            logger.error("PostgreSQL JDBC Driver not found!", e);
            throw new ExceptionInInitializerError(e);
        }
    }

    /**
     * Get database connection
     * @return Connection object (dari PostgreSQL)
     * @throws SQLException jika connection gagal
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            logger.debug("PostgreSQL connection established successfully");
            return conn;
        } catch (SQLException e) {
            logger.error("Failed to establish PostgreSQL connection", e);
            logger.error("URL: {}", URL);
            logger.error("User: {}", USER);
            logger.error("Error Code: {}", e.getSQLState());
            throw e;
        }
    }

    /**
     * Test connection (untuk debugging)
     * @return true jika berhasil, false jika gagal
     */
    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            if (conn != null && !conn.isClosed()) {
                logger.info("✅ Connection test PASSED");
                logger.info("Database: {}", conn.getCatalog());
                logger.info("User: {}", conn.getMetaData().getUserName());
                return true;
            }
        } catch (SQLException e) {
            logger.error("❌ Connection test FAILED: {}", e.getMessage());
            return false;
        }
        return false;
    }
}
