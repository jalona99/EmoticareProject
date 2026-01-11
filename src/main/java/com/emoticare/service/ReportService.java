package com.emoticare.service;

import com.emoticare.dao.ReportDAO;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@Service
public class ReportService {

    private final ReportDAO reportDAO = new ReportDAO();

    public Map<String, Integer> getModuleCompletionStats() throws SQLException {
        return reportDAO.getModuleCompletionStats();
    }

    public List<Map<String, Object>> getAllQuizScores() throws SQLException {
        return reportDAO.getAllQuizScores();
    }

    public List<Map<String, Object>> getAllBadgesEarned() throws SQLException {
        return reportDAO.getAllBadgesEarned();
    }

    public Map<String, Integer> getForumStats() throws SQLException {
        return reportDAO.getForumStats();
    }
}
