package com.emoticare.db;

import com.emoticare.dao.DatabaseConnection;
import org.junit.Test;
import static org.junit.Assert.assertTrue;

public class ConnectionTest {

    @Test
    public void testDbConnection() {
        System.out.println("Running Database Connection Test...");
        boolean isConnected = DatabaseConnection.testConnection();
        assertTrue("Database connection failed. Check credentials and if Postgres is running.", isConnected);
        System.out.println("Database Connection Verified Successfully!");
    }
}
