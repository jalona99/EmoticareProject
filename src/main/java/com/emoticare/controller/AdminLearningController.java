package com.emoticare.controller;

import com.emoticare.model.Module;
import com.emoticare.service.LearningService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/learning")
public class AdminLearningController {

    @Autowired
    private LearningService learningService;

    // List all modules
    @GetMapping
    public String listModules(Model model) {
        try {
            model.addAttribute("modules", learningService.getAllModules());
            return "admin/learning-list";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "Error loading modules");
            return "error";
        }
    }

    // Show Create Form
    @GetMapping("/create")
    public String showCreateForm(Model model) {
        model.addAttribute("module", new Module());
        model.addAttribute("isEdit", false);
        return "admin/module-form";
    }

    // Process Creation
    @PostMapping("/create")
    public String createModule(@ModelAttribute Module module) {
        try {
            learningService.createModule(module);
            return "redirect:/admin/learning";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/learning?error=create_failed";
        }
    }

    // Show Edit Form
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") int id, Model model) {
        try {
            Module module = learningService.getModuleById(id);
            if (module == null) {
                return "redirect:/admin/learning?error=not_found";
            }
            model.addAttribute("module", module);
            model.addAttribute("isEdit", true);
            return "admin/module-form";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/learning";
        }
    }

    // Process Update
    @PostMapping("/update")
    public String updateModule(@ModelAttribute Module module) {
        try {
            learningService.updateModule(module);
            return "redirect:/admin/learning";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/learning?error=update_failed";
        }
    }

    // Process Delete
    @PostMapping("/delete")
    public String deleteModule(@RequestParam("id") int id) {
        try {
            learningService.deleteModule(id);
            return "redirect:/admin/learning";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/learning?error=delete_failed";
        }
    }
}
