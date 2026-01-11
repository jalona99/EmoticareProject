package com.emoticare.controller;

import com.emoticare.model.ForumComment;
import com.emoticare.model.ForumPost;
import com.emoticare.model.User;
import com.emoticare.service.ForumService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.sql.SQLException;
import java.util.List;

@Controller
@RequestMapping("/forum")
public class ForumController {

    @Autowired
    private ForumService forumService;

    @GetMapping
    public String index(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null)
            return "redirect:/login";

        try {
            List<ForumPost> posts = forumService.getAllPosts();
            model.addAttribute("posts", posts);
        } catch (SQLException e) {
            e.printStackTrace();
            model.addAttribute("error", "Error loading forum posts.");
        }
        return "user/forum-list";
    }

    @PostMapping("/post/create")
    public String createPost(@RequestParam("title") String title, @RequestParam("content") String content,
            HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null)
            return "redirect:/login";

        ForumPost post = new ForumPost();
        post.setUserId(user.getId());
        post.setTitle(title);
        post.setContent(content);

        try {
            forumService.createPost(post);
            redirectAttributes.addFlashAttribute("success", "Post created successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Error creating post.");
        }
        return "redirect:/forum";
    }

    @GetMapping("/post/{id}")
    public String viewPost(@PathVariable("id") int id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null)
            return "redirect:/login";

        try {
            ForumPost post = forumService.getPostById(id);
            List<ForumComment> comments = forumService.getComments(id);

            model.addAttribute("post", post);
            model.addAttribute("comments", comments);
        } catch (SQLException e) {
            e.printStackTrace();
            model.addAttribute("error", "Error loading post.");
            return "redirect:/forum";
        }
        return "user/forum-post";
    }

    @PostMapping("/comment/add")
    public String addComment(@RequestParam("postId") int postId, @RequestParam("content") String content,
            HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null)
            return "redirect:/login";

        ForumComment comment = new ForumComment();
        comment.setPostId(postId);
        comment.setUserId(user.getId());
        comment.setContent(content);

        try {
            forumService.addComment(comment);
            redirectAttributes.addFlashAttribute("success", "Comment added.");
        } catch (SQLException e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Error adding comment.");
        }
        return "redirect:/forum/post/" + postId;
    }

    @GetMapping("/like/{postId}")
    public String likePost(@PathVariable("postId") int postId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null)
            return "redirect:/login";

        try {
            forumService.toggleLike(postId, user.getId());
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // Redirect back to referring page ideally, or post view
        return "redirect:/forum/post/" + postId;
    }

    @PostMapping("/post/report")
    public String reportPost(@RequestParam("postId") int postId, @RequestParam("reason") String reason,
            HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null)
            return "redirect:/login";

        try {
            forumService.reportPost(postId, reason);
            redirectAttributes.addFlashAttribute("success", "Post reported to moderators.");
        } catch (SQLException e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Error reporting post.");
        }
        return "redirect:/forum";
    }
}
