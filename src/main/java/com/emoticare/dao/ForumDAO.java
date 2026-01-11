package com.emoticare.dao;

import com.emoticare.model.ForumComment;
import com.emoticare.model.ForumPost;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ForumDAO {
    private static final Logger logger = LoggerFactory.getLogger(ForumDAO.class);

    // --- Post Operations ---

    public boolean createPost(ForumPost post) throws SQLException {
        String sql = "INSERT INTO forum_posts (user_id, title, content, created_at, updated_at) " +
                "VALUES (?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) RETURNING id";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, post.getUserId());
            pstmt.setString(2, post.getTitle());
            pstmt.setString(3, post.getContent());

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    post.setId(rs.getInt("id"));
                    return true;
                }
            }
        }
        return false;
    }

    public List<ForumPost> getAllPosts() throws SQLException {
        List<ForumPost> posts = new ArrayList<>();
        // Join with users table for username
        // Subqueries for comment_count and like_count
        String sql = "SELECT p.*, u.username, " +
                "(SELECT COUNT(*) FROM forum_comments c WHERE c.post_id = p.id) as comment_count, " +
                "(SELECT COUNT(*) FROM forum_likes l WHERE l.post_id = p.id) as like_count " +
                "FROM forum_posts p " +
                "JOIN users u ON p.user_id = u.id " +
                "WHERE p.is_deleted = FALSE " + // Filter deleted
                "ORDER BY p.created_at DESC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                posts.add(mapRowToPost(rs));
            }
        }
        return posts;
    }

    public ForumPost getPostById(int id) throws SQLException {
        String sql = "SELECT p.*, u.username, " +
                "(SELECT COUNT(*) FROM forum_comments c WHERE c.post_id = p.id) as comment_count, " +
                "(SELECT COUNT(*) FROM forum_likes l WHERE l.post_id = p.id) as like_count " +
                "FROM forum_posts p " +
                "JOIN users u ON p.user_id = u.id " +
                "WHERE p.id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToPost(rs);
                }
            }
        }
        return null;
    }

    public boolean deletePost(int id) throws SQLException {
        // Soft delete
        String sql = "UPDATE forum_posts SET is_deleted = TRUE WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean reportPost(int id, String reason) throws SQLException {
        String sql = "UPDATE forum_posts SET is_reported = TRUE, report_reason = ? WHERE id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, reason);
            pstmt.setInt(2, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    public List<ForumPost> getReportedPosts() throws SQLException {
        List<ForumPost> posts = new ArrayList<>();
        String sql = "SELECT p.*, u.username, " +
                "(SELECT COUNT(*) FROM forum_comments c WHERE c.post_id = p.id) as comment_count, " +
                "(SELECT COUNT(*) FROM forum_likes l WHERE l.post_id = p.id) as like_count " +
                "FROM forum_posts p " +
                "JOIN users u ON p.user_id = u.id " +
                "WHERE p.is_reported = TRUE AND p.is_deleted = FALSE " +
                "ORDER BY p.created_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                posts.add(mapRowToPost(rs));
            }
        }
        return posts;
    }

    public List<ForumPost> getDeletedPosts() throws SQLException {
        List<ForumPost> posts = new ArrayList<>();
        String sql = "SELECT p.*, u.username, " +
                "(SELECT COUNT(*) FROM forum_comments c WHERE c.post_id = p.id) as comment_count, " +
                "(SELECT COUNT(*) FROM forum_likes l WHERE l.post_id = p.id) as like_count " +
                "FROM forum_posts p " +
                "JOIN users u ON p.user_id = u.id " +
                "WHERE p.is_deleted = TRUE " +
                "ORDER BY p.updated_at DESC";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql);
                ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                posts.add(mapRowToPost(rs));
            }
        }
        return posts;
    }

    // --- Comment Operations ---

    public boolean createComment(ForumComment comment) throws SQLException {
        String sql = "INSERT INTO forum_comments (post_id, user_id, content, created_at) " +
                "VALUES (?, ?, ?, CURRENT_TIMESTAMP) RETURNING id";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, comment.getPostId());
            pstmt.setInt(2, comment.getUserId());
            pstmt.setString(3, comment.getContent());

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    comment.setId(rs.getInt("id"));
                    return true;
                }
            }
        }
        return false;
    }

    public List<ForumComment> getCommentsByPostId(int postId) throws SQLException {
        List<ForumComment> comments = new ArrayList<>();
        String sql = "SELECT c.*, u.username " +
                "FROM forum_comments c " +
                "JOIN users u ON c.user_id = u.id " +
                "WHERE c.post_id = ? " +
                "ORDER BY c.created_at ASC";

        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, postId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    comments.add(mapRowToComment(rs));
                }
            }
        }
        return comments;
    }

    // --- Like Operations ---

    public boolean hasLiked(int postId, int userId) throws SQLException {
        String sql = "SELECT 1 FROM forum_likes WHERE post_id = ? AND user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, postId);
            pstmt.setInt(2, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void addLike(int postId, int userId) throws SQLException {
        String sql = "INSERT INTO forum_likes (post_id, user_id, created_at) VALUES (?, ?, CURRENT_TIMESTAMP) ON CONFLICT DO NOTHING";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, postId);
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();
        }
    }

    public void removeLike(int postId, int userId) throws SQLException {
        String sql = "DELETE FROM forum_likes WHERE post_id = ? AND user_id = ?";
        try (Connection conn = DatabaseConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, postId);
            pstmt.setInt(2, userId);
            pstmt.executeUpdate();
        }
    }

    // --- Helpers ---

    private ForumPost mapRowToPost(ResultSet rs) throws SQLException {
        ForumPost p = new ForumPost();
        p.setId(rs.getInt("id"));
        p.setUserId(rs.getInt("user_id"));
        p.setUsername(rs.getString("username"));
        p.setTitle(rs.getString("title"));
        p.setContent(rs.getString("content"));
        p.setFlagged(rs.getBoolean("is_reported")); // Mapping reported to flagged
        p.setReportReason(rs.getString("report_reason"));
        p.setCommentCount(rs.getInt("comment_count"));
        p.setLikeCount(rs.getInt("like_count"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null)
            p.setCreatedAt(createdAt.toLocalDateTime());
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (updatedAt != null)
            p.setUpdatedAt(updatedAt.toLocalDateTime());

        return p;
    }

    private ForumComment mapRowToComment(ResultSet rs) throws SQLException {
        ForumComment c = new ForumComment();
        c.setId(rs.getInt("id"));
        c.setPostId(rs.getInt("post_id"));
        c.setUserId(rs.getInt("user_id"));
        c.setUsername(rs.getString("username"));
        c.setContent(rs.getString("content"));

        Timestamp createdAt = rs.getTimestamp("created_at");
        if (createdAt != null)
            c.setCreatedAt(createdAt.toLocalDateTime());

        return c;
    }
}
