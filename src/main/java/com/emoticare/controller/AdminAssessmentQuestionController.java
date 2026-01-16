package com.emoticare.controller;

import com.emoticare.dao.AssessmentTypeDAO;
import com.emoticare.dao.QuestionDAO;
import com.emoticare.model.AssessmentQuestion;
import com.emoticare.model.AssessmentType;
import com.emoticare.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin/assessments/questions")
public class AdminAssessmentQuestionController {

    private boolean isAdmin(User user, HttpSession session) {
        if (user != null && user.getRoleId() == 4) return true;
        Integer roleId = (Integer) session.getAttribute("roleId");
        return roleId != null && roleId == 4;
    }

    @GetMapping("/type/{typeId}")
    public String listQuestions(@PathVariable int typeId, HttpSession session, Model model) {
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current, session)) return "redirect:/login";

        AssessmentType type = AssessmentTypeDAO.getAssessmentTypeById(typeId);
        List<AssessmentQuestion> questions = QuestionDAO.getQuestionsByType(typeId);

        model.addAttribute("username", current.getUsername());
        model.addAttribute("assessmentType", type);
        model.addAttribute("questions", questions);

        return "admin_assessment_questions";
    }

    @GetMapping("/add")
    public String showAddForm(@RequestParam int typeId, HttpSession session, Model model) {
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current, session)) return "redirect:/login";

        AssessmentType type = AssessmentTypeDAO.getAssessmentTypeById(typeId);
        AssessmentQuestion question = new AssessmentQuestion();
        question.setAssessmentTypeId(typeId);
        
        // Suggest next order
        List<AssessmentQuestion> existing = QuestionDAO.getQuestionsByType(typeId);
        question.setQuestionOrder(existing.size() + 1);

        model.addAttribute("username", current.getUsername());
        model.addAttribute("assessmentType", type);
        model.addAttribute("question", question);
        model.addAttribute("isEdit", false);

        return "admin_assessment_question_form";
    }

    @PostMapping("/add")
    public String addQuestion(@ModelAttribute AssessmentQuestion question, HttpSession session) {
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current, session)) return "redirect:/login";

        QuestionDAO.createQuestion(question);
        return "redirect:/admin/assessments/questions/type/" + question.getAssessmentTypeId();
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable int id, HttpSession session, Model model) {
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current, session)) return "redirect:/login";

        AssessmentQuestion question = QuestionDAO.getQuestionById(id);
        AssessmentType type = AssessmentTypeDAO.getAssessmentTypeById(question.getAssessmentTypeId());

        model.addAttribute("username", current.getUsername());
        model.addAttribute("assessmentType", type);
        model.addAttribute("question", question);
        model.addAttribute("isEdit", true);

        return "admin_assessment_question_form";
    }

    @PostMapping("/edit")
    public String editQuestion(@ModelAttribute AssessmentQuestion question, HttpSession session) {
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current, session)) return "redirect:/login";

        QuestionDAO.updateQuestion(question);
        return "redirect:/admin/assessments/questions/type/" + question.getAssessmentTypeId();
    }

    @PostMapping("/delete/{id}")
    public String deleteQuestion(@PathVariable int id, @RequestParam int typeId, HttpSession session) {
        User current = (User) session.getAttribute("user");
        if (!isAdmin(current, session)) return "redirect:/login";

        QuestionDAO.deleteQuestion(id);
        return "redirect:/admin/assessments/questions/type/" + typeId;
    }
}
