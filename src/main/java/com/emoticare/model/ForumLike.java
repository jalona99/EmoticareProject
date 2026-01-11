package com.emoticare.model;

import java.time.LocalDateTime;

public class ForumLike {
    private int postId;
    private int userId;
    private LocalDateTime createdAt;

    public ForumLike() {
    }

    public ForumLike(int postId, int userId) {
        this.postId = postId;
        this.userId = userId;
    }

    public int getPostId() {
        return postId;
    }

    public void setPostId(int postId) {
        this.postId = postId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
