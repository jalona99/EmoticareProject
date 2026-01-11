package com.emoticare.controller;

import com.emoticare.model.ForumPost;
import com.emoticare.model.User;
import com.emoticare.service.ForumService;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin/forum")
public class AdminForumController {

    @Autowired
    private ForumService forumService;

    @GetMapping
    public String forumManage(@RequestParam(value = "tab", defaultValue = "active") String tab, Model model) {
        try {
            List<ForumPost> posts;
            switch (tab) {
                case "reported":
                    posts = forumService.getReportedPosts();
                    break;
                case "deleted":
                    posts = forumService.getDeletedPosts();
                    break;
                default:
                    posts = forumService.getAllPosts(); // Assuming this now returns active posts
                    break;
            }
            model.addAttribute("posts", posts);
            model.addAttribute("currentTab", tab);
            return "admin/forum-manage";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/dashboard?error=forum_load_failed";
        }
    }

    @PostMapping("/delete")
    public String deletePost(@RequestParam("id") int id) {
        try {
            forumService.deletePost(id);
            return "redirect:/admin/forum";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/forum?error=delete_failed";
        }
    }

    @PostMapping("/create")
    public String createPost(@RequestParam("title") String title,
            @RequestParam("content") String content,
            HttpSession session) {
        User user = (User) session.getAttribute("user");
        // Fallback if session expired, though AuthInterceptor should catch it.
        // Admin usually has an ID.
        if (user == null)
            return "redirect:/login";

        try {
            ForumPost post = new ForumPost();
            post.setUserId(user.getId());
            post.setTitle(title);
            post.setContent(content);
            forumService.createAdminPost(post);
            return "redirect:/admin/forum";
        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/admin/forum?error=create_failed";
        }
    }
}
