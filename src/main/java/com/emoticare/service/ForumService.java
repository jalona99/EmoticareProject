package com.emoticare.service;

import com.emoticare.dao.ForumDAO;
import com.emoticare.model.ForumComment;
import com.emoticare.model.ForumPost;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.util.List;

@Service
public class ForumService {

    private final ForumDAO forumDAO = new ForumDAO();

    public List<ForumPost> getAllPosts() throws SQLException {
        return forumDAO.getAllPosts();
    }

    public boolean createPost(ForumPost post) throws SQLException {
        return forumDAO.createPost(post);
    }

    public ForumPost getPostById(int id) throws SQLException {
        return forumDAO.getPostById(id);
    }

    public void deletePost(int id) throws SQLException {
        forumDAO.deletePost(id);
    }

    public void reportPost(int id, String reason) throws SQLException {
        forumDAO.reportPost(id, reason);
    }

    public List<ForumPost> getReportedPosts() throws SQLException {
        return forumDAO.getReportedPosts();
    }

    public List<ForumPost> getDeletedPosts() throws SQLException {
        return forumDAO.getDeletedPosts();
    }

    public boolean createAdminPost(ForumPost post) throws SQLException {
        return forumDAO.createPost(post);
    }

    public boolean addComment(ForumComment comment) throws SQLException {
        return forumDAO.createComment(comment);
    }

    public List<ForumComment> getComments(int postId) throws SQLException {
        return forumDAO.getCommentsByPostId(postId);
    }

    public void toggleLike(int postId, int userId) throws SQLException {
        if (forumDAO.hasLiked(postId, userId)) {
            forumDAO.removeLike(postId, userId);
        } else {
            forumDAO.addLike(postId, userId);
        }
    }
}
