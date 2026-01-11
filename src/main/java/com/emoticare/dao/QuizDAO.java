package com.emoticare.dao;

import com.emoticare.model.Question;
import com.emoticare.model.Quiz;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizDAO {
    private static final Logger logger = LoggerFactory.getLogger(QuizDAO.class);

    // --- Quiz Operations ---

    public boolean createQuiz(Quiz quiz) throws SQLException {
        String sql = "INSERT INTO quizzes (module_id, title, passing_score, created_at, updated_at) " +
                "VALUES (?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING id";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, quiz.getModuleId());
            pstmt.setString(2, quiz.getTitle());
            pstmt.setInt(3, quiz.getPassingScore());
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    quiz.setId(rs.getInt("id"));
                    return true;
                }
            }
        }
        return false;
    }

    public boolean updateQuiz(Quiz quiz) throws SQLException {
        String sql = "UPDATE quizzes SET title = ?, passing_score = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, quiz.getTitle());
            pstmt.setInt(2, quiz.getPassingScore());
            pstmt.setInt(3, quiz.getId());
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteQuiz(int id) throws SQLException {
        String sql = "DELETE FROM quizzes WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    public Quiz getQuizByModuleId(int moduleId) throws SQLException {
        String sql = "SELECT * FROM quizzes WHERE module_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, moduleId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToQuiz(rs);
                }
            }
        }
        return null;
    }

    public Quiz getQuizById(int id) throws SQLException {
        String sql = "SELECT * FROM quizzes WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToQuiz(rs);
                }
            }
        }
        return null;
    }

    // --- Question Operations ---

    public void addQuestion(Question question) throws SQLException {
        String sql = "INSERT INTO quiz_questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, question.getQuizId());
            pstmt.setString(2, question.getQuestionText());
            pstmt.setString(3, question.getOptionA());
            pstmt.setString(4, question.getOptionB());
            pstmt.setString(5, question.getOptionC());
            pstmt.setString(6, question.getOptionD());
            pstmt.setString(7, question.getCorrectOption());
            pstmt.executeUpdate();
        }
    }

    public void deleteQuestion(int id) throws SQLException {
        String sql = "DELETE FROM quiz_questions WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        }
    }

    public List<Question> getQuestionsByQuizId(int quizId) throws SQLException {
        List<Question> questions = new ArrayList<>();
        String sql = "SELECT * FROM quiz_questions WHERE quiz_id = ? ORDER BY id ASC";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, quizId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    questions.add(mapRowToQuestion(rs));
                }
            }
        }
        return questions;
    }

    // --- Helpers ---

    private Quiz mapRowToQuiz(ResultSet rs) throws SQLException {
        Quiz quiz = new Quiz();
        quiz.setId(rs.getInt("id"));
        quiz.setModuleId(rs.getInt("module_id"));
        quiz.setTitle(rs.getString("title"));
        quiz.setPassingScore(rs.getInt("passing_score"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null)
            quiz.setCreatedAt(createdAt.toLocalDateTime());
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null)
            quiz.setUpdatedAt(updatedAt.toLocalDateTime());

        return quiz;
    }

    private Question mapRowToQuestion(ResultSet rs) throws SQLException {
        Question q = new Question();
        q.setId(rs.getInt("id"));
        q.setQuizId(rs.getInt("quiz_id"));
        q.setQuestionText(rs.getString("question_text"));
        q.setOptionA(rs.getString("option_a"));
        q.setOptionB(rs.getString("option_b"));
        q.setOptionC(rs.getString("option_c"));
        q.setOptionD(rs.getString("option_d"));
        q.setCorrectOption(rs.getString("correct_option"));
        return q;
    }
}
