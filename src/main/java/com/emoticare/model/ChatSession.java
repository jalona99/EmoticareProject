package com.emoticare.model;

import java.time.LocalDateTime;

public class ChatSession {
    private int id;
    private int userId;
    private String title;
    private LocalDateTime createdAt;

    public ChatSession() {}

    public ChatSession(int userId, String title) {
        this.userId = userId;
        this.title = title;
        this.createdAt = LocalDateTime.now();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
