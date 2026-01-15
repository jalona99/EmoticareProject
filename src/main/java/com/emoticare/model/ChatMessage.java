package com.emoticare.model;

import java.time.LocalDateTime;

public class ChatMessage {
    private int id;
    private int sessionId;
    private String sender; // 'USER' or 'AI'
    private String content;
    private LocalDateTime createdAt;

    public ChatMessage() {}

    public ChatMessage(int sessionId, String sender, String content) {
        this.sessionId = sessionId;
        this.sender = sender;
        this.content = content;
        this.createdAt = LocalDateTime.now();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSessionId() {
        return sessionId;
    }

    public void setSessionId(int sessionId) {
        this.sessionId = sessionId;
    }

    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
