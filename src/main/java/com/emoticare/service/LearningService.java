package com.emoticare.service;

import com.emoticare.dao.ModuleDAO;
import com.emoticare.dao.ProgressDAO;
import com.emoticare.dao.QuizDAO;
import com.emoticare.model.Badge;
import com.emoticare.model.Module;
import com.emoticare.model.Question;
import com.emoticare.model.Quiz;
import com.emoticare.model.UserProgress;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class LearningService {

    private final ModuleDAO moduleDAO = new ModuleDAO();
    private final QuizDAO quizDAO = new QuizDAO();
    private final ProgressDAO progressDAO = new ProgressDAO();

    // --- Modules ---
    public List<Module> getAllModules() throws SQLException {
        return moduleDAO.getAllModules();
    }

    public Module getModuleById(int id) throws SQLException {
        return moduleDAO.getModuleById(id);
    }

    public boolean createModule(Module module) throws SQLException {
        return moduleDAO.createModule(module);
    }

    public boolean updateModule(Module module) throws SQLException {
        return moduleDAO.updateModule(module);
    }

    public boolean deleteModule(int id) throws SQLException {
        return moduleDAO.deleteModule(id);
    }

    // --- Quizzes ---
    public boolean createQuiz(Quiz quiz) throws SQLException {
        return quizDAO.createQuiz(quiz);
    }

    public boolean updateQuiz(Quiz quiz) throws SQLException {
        return quizDAO.updateQuiz(quiz);
    }

    public boolean deleteQuiz(int id) throws SQLException {
        return quizDAO.deleteQuiz(id);
    }

    public Quiz getQuizByModuleId(int moduleId) throws SQLException {
        return quizDAO.getQuizByModuleId(moduleId);
    }

    public Quiz getQuizById(int id) throws SQLException {
        return quizDAO.getQuizById(id);
    }

    public void addQuestionToQuiz(Question question) throws SQLException {
        quizDAO.addQuestion(question);
    }

    public void deleteQuestion(int id) throws SQLException {
        quizDAO.deleteQuestion(id);
    }

    public List<Question> getQuizQuestions(int quizId) throws SQLException {
        return quizDAO.getQuestionsByQuizId(quizId);
    }

    // --- Learning Process ---
    public void submitQuiz(int userId, int moduleId, int score) throws SQLException {
        Quiz quiz = quizDAO.getQuizByModuleId(moduleId);
        if (quiz == null)
            return;

        UserProgress progress = new UserProgress();
        progress.setUserId(userId);
        progress.setModuleId(moduleId);
        progress.setQuizScore(score);

        if (score >= quiz.getPassingScore()) {
            progress.setStatus("COMPLETED");
            progress.setCompletedAt(LocalDateTime.now());

            // Check for badges
            checkForBadges(userId, moduleId);
        } else {
            progress.setStatus("IN_PROGRESS");
        }

        progressDAO.upsertProgress(progress);
    }

    private void checkForBadges(int userId, int moduleId) throws SQLException {
        // Check for specific module badges
        List<Badge> allBadges = progressDAO.getAllBadges();
        for (Badge badge : allBadges) {
            if (badge.getCriteriaModuleId() != null && badge.getCriteriaModuleId() == moduleId) {
                progressDAO.awardBadge(userId, badge.getId());
            }
        }

        // Example: First Module Badge (if tracking count)
        // ideally we'd query count of completed modules here
    }

    public UserProgress getUserProgress(int userId, int moduleId) throws SQLException {
        return progressDAO.getUserProgress(userId, moduleId);
    }

    public List<Badge> getUserBadges(int userId) throws SQLException {
        return progressDAO.getUserBadges(userId);
    }

    // --- Badges ---

    public List<Badge> getAllBadges() throws SQLException {
        return progressDAO.getAllBadges();
    }

    public boolean createBadge(Badge badge) throws SQLException {
        return progressDAO.createBadge(badge);
    }

    public boolean deleteBadge(int id) throws SQLException {
        return progressDAO.deleteBadge(id);
    }
}
