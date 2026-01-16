package com.emoticare.controller;

import com.emoticare.model.ChatMessage;
import com.emoticare.model.ChatSession;
import com.emoticare.model.User;
import com.emoticare.service.ChatService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/ai/support")
public class ChatController {

    @Autowired
    private ChatService chatService;

    @GetMapping("")
    public String showChatPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        try {
            List<ChatSession> sessions = chatService.getUserSessions(user.getId());
            model.addAttribute("sessions", sessions);
            model.addAttribute("username", user.getUsername());
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return "chatbot";
    }

    @GetMapping("/{sessionId}")
    @ResponseBody
    public List<Map<String, String>> getMessages(@PathVariable int sessionId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return List.of();

        try {
            List<ChatMessage> messages = chatService.getSessionMessages(sessionId);
            List<Map<String, String>> payload = new ArrayList<>();
            for (ChatMessage message : messages) {
                Map<String, String> entry = new HashMap<>();
                entry.put("sender", message.getSender());
                entry.put("content", message.getContent());
                payload.add(entry);
            }
            return payload;
        } catch (SQLException e) {
            e.printStackTrace();
            return List.of();
        }
    }

    @PostMapping("/send")
    @ResponseBody
    public Map<String, Object> sendMessage(@RequestParam(required = false) Integer sessionId,
                                         @RequestParam String message,
                                         HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.put("success", false);
            response.put("error", "Unauthorized");
            return response;
        }

        try {
            // 1. Create session if it doesn't exist
            if (sessionId == null || sessionId <= 0) {
                sessionId = chatService.startNewSession(user.getId(), message);
                response.put("newSession", true);
                response.put("sessionId", sessionId);
                response.put("title", message.length() > 30 ? message.substring(0, 27) + "..." : message);
            }

            // 2. Save user message
            chatService.saveMessage(sessionId, "USER", message);

            // 3. Record risk alert (no chat content stored)
            chatService.recordRiskAlertIfNeeded(user.getId(), sessionId, message);

            // 4. Get AI response
            String aiResponseText = chatService.getAIResponse(message);

            // 5. Save AI message
            chatService.saveMessage(sessionId, "AI", aiResponseText);

            response.put("success", true);
            response.put("aiResponse", aiResponseText);
            response.put("sessionId", sessionId);

        } catch (SQLException e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("error", "Database error");
        }

        return response;
    }

    @DeleteMapping("/{sessionId}")
    @ResponseBody
    public Map<String, Object> deleteSession(@PathVariable int sessionId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.put("success", false);
            return response;
        }

        try {
            chatService.deleteSession(sessionId);
            response.put("success", true);
        } catch (SQLException e) {
            e.printStackTrace();
            response.put("success", false);
        }

        return response;
    }
}
