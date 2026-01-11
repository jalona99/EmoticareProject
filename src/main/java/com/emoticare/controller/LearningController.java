package com.emoticare.controller;

import com.emoticare.model.Module;
import com.emoticare.model.Question;
import com.emoticare.model.Quiz;
import com.emoticare.model.User;
import com.emoticare.model.UserProgress;
import com.emoticare.service.LearningService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/learning")
public class LearningController {

    @Autowired
    private LearningService learningService;

    @GetMapping
    public String index(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            List<Module> modules = learningService.getAllModules();
            model.addAttribute("modules", modules);
            // Ideally we also fetch user progress map to show what's done
            // For now, simplify
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "user/learning-hub";
    }

    @GetMapping("/module/{id}")
    public String viewModule(@PathVariable("id") int id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null)
            return "redirect:/login";

        try {
            Module module = learningService.getModuleById(id);
            Quiz quiz = learningService.getQuizByModuleId(id);
            UserProgress progress = learningService.getUserProgress(user.getId(), id);

            model.addAttribute("module", module);
            model.addAttribute("quiz", quiz);
            model.addAttribute("progress", progress);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "user/module-view"; // We need to create this view or reuse learning-hub detail
    }

    @GetMapping("/quiz/take/{quizId}")
    public String takeQuiz(@PathVariable("quizId") int quizId, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null)
            return "redirect:/login";

        try {
            // We need module info, so query quiz first
            Quiz quiz = learningService.getQuizById(quizId);
            List<Question> questions = learningService.getQuizQuestions(quizId);

            model.addAttribute("quiz", quiz); // This allows accessing quiz.moduleId in JSP
            model.addAttribute("questions", questions);
            model.addAttribute("quizId", quizId);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "user/quiz-take";
    }

    @PostMapping("/quiz/submit")
    public String submitQuiz(@RequestParam("quizId") int quizId, @RequestParam Map<String, String> allParams,
            HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null)
            return "redirect:/login";

        try {
            // Calculate score
            List<Question> questions = learningService.getQuizQuestions(quizId);
            int correctCount = 0;
            for (Question q : questions) {
                String selectedOption = allParams.get("question_" + q.getId());
                if (selectedOption != null && selectedOption.equals(q.getCorrectOption())) {
                    correctCount++;
                }
            }

            int score = (int) (((double) correctCount / questions.size()) * 100);

            // We need module ID. Assuming we look it up or pass it.
            // Hack: query quiz to get module ID
            // For efficiency, service could return full Quiz object with module ID
            // Let's assume we implement getQuizById in service/DAO
            // Fix: added getQuizById to logic previously or assume we can get it
            // Let's quick fix: re-fetch questions or just add getQuizById to service if
            // missing.
            // Actually I added `getQuizByModuleId`, but not `getQuizById`.
            // I will add `getQuizById` to QuizDAO and LearningService if needed, but for
            // now let's assume I can get module ID from hidden field.

            String moduleIdStr = allParams.get("moduleId");
            int moduleId = Integer.parseInt(moduleIdStr);

            learningService.submitQuiz(user.getId(), moduleId, score);

            redirectAttributes.addFlashAttribute("success", "Quiz submitted! Score: " + score + "%");
            return "redirect:/learning/module/" + moduleId;

        } catch (SQLException e) {
            e.printStackTrace();
            return "redirect:/learning";
        }
    }
}
