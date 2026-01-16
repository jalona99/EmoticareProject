package com.emoticare.controller;

import com.emoticare.dao.DatabaseConnection;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import java.sql.Connection;
import java.sql.DatabaseMetaData;

@Controller
public class DiagnosticController {

    @GetMapping("/admin/debug/db")
    public String checkDatabase(Model model) {
        try (Connection conn = DatabaseConnection.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                DatabaseMetaData metaData = conn.getMetaData();
                model.addAttribute("status", "SUCCESS");
                model.addAttribute("database", metaData.getDatabaseProductName());
                model.addAttribute("version", metaData.getDatabaseProductVersion());
                model.addAttribute("driver", metaData.getDriverName());
                model.addAttribute("url", metaData.getURL());
                model.addAttribute("user", metaData.getUserName());
            } else {
                model.addAttribute("status", "FAILED");
                model.addAttribute("error", "Connection is null or closed");
            }
        } catch (Exception e) {
            model.addAttribute("status", "ERROR");
            model.addAttribute("error", e.getMessage());
            e.printStackTrace();
        }
        return "db-diagnostic";
    }
}
