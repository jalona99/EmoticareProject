package com.emoticare.util;

import com.emoticare.dao.DatabaseConnection;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class SchemaUpdater {
    public static void main(String[] args) {
        String sqlFile = "f:/Documents/GitHub/EmoticareProject/src/main/resources/enhance_forum_schema.sql";
        try (Connection conn = DatabaseConnection.getConnection();
                Statement stmt = conn.createStatement()) {

            String sql = new String(Files.readAllBytes(Paths.get(sqlFile)));
            // Split by semicolon if multiple statements, but executeUpdate might handle it
            // depending on driver
            // PostgreSQL driver usually allows multiple statements if enabled, but let's
            // try simple execution first
            // Or just read the file content and execute.

            stmt.executeUpdate(sql);
            System.out.println("Schema updated successfully!");

        } catch (SQLException | IOException e) {
            e.printStackTrace();
        }
    }
}
