<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>${post.title} - EmotiCare Forum</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
            <style>
                body {
                    font-family: 'Inter', sans-serif;
                    background: #1a1d2e;
                    color: #ffffff;
                    margin: 0;
                    padding: 40px 20px;
                    min-height: 100vh;
                }

                .container {
                    max-width: 800px;
                    margin: 0 auto;
                }

                .back-link {
                    color: #6366f1;
                    text-decoration: none;
                    font-weight: 600;
                    display: inline-block;
                    margin-bottom: 20px;
                }

                .back-link:hover {
                    text-decoration: underline;
                }

                .post-container {
                    background: #242838;
                    border: 1px solid #2d3142;
                    border-radius: 16px;
                    padding: 30px;
                    margin-bottom: 30px;
                }

                h1 {
                    margin: 0 0 10px 0;
                    font-size: 28px;
                }

                .meta {
                    color: #9ca3af;
                    font-size: 14px;
                    margin-bottom: 20px;
                    padding-bottom: 20px;
                    border-bottom: 1px solid #2d3142;
                }

                .content {
                    line-height: 1.6;
                    font-size: 16px;
                    color: #e2e8f0;
                    margin-bottom: 24px;
                }

                .like-btn {
                    background: #1a1d2e;
                    border: 1px solid #6366f1;
                    color: #6366f1;
                    padding: 8px 16px;
                    border-radius: 8px;
                    text-decoration: none;
                    font-weight: 600;
                    display: inline-block;
                    transition: all 0.2s;
                }

                .like-btn:hover {
                    background: #6366f1;
                    color: white;
                }

                /* Comments Section */
                h3 {
                    font-size: 18px;
                    color: #fff;
                    margin-bottom: 20px;
                }

                .comment-form textarea {
                    width: 100%;
                    padding: 12px;
                    background: #1a1d2e;
                    border: 1px solid #2d3142;
                    border-radius: 8px;
                    color: white;
                    font-family: inherit;
                    margin-bottom: 10px;
                    box-sizing: border-box;
                }

                .comment-form textarea:focus {
                    outline: none;
                    border-color: #6366f1;
                }

                .btn-submit {
                    background: #10b981;
                    color: white;
                    border: none;
                    padding: 10px 20px;
                    border-radius: 8px;
                    font-weight: 600;
                    cursor: pointer;
                }

                .btn-submit:hover {
                    background: #059669;
                }

                .comment {
                    background: #242838;
                    border: 1px solid #2d3142;
                    padding: 16px;
                    border-radius: 12px;
                    margin-bottom: 16px;
                }

                .comment-header {
                    font-size: 14px;
                    margin-bottom: 6px;
                }

                .comment-header strong {
                    color: #fff;
                }

                .comment-header span {
                    color: #9ca3af;
                    font-size: 12px;
                    margin-left: 8px;
                }

                .comment-text {
                    color: #d1d5db;
                    font-size: 15px;
                    margin: 0;
                    line-height: 1.5;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <a href="${pageContext.request.contextPath}/forum" class="back-link">← Back to Forum</a>

                <div class="post-container">
                    <h1>${post.title}</h1>
                    <div class="meta">By ${post.username} • ${post.createdAt}</div>
                    <div class="content">${post.content}</div>

                    <a href="${pageContext.request.contextPath}/forum/like/${post.id}" class="like-btn">
                        👍 Like (${post.likeCount})
                    </a>
                </div>

                <h3>Comments (${comments.size()})</h3>

                <div style="margin-bottom: 30px;" class="comment-form">
                    <form action="${pageContext.request.contextPath}/forum/comment/add" method="post">
                        <input type="hidden" name="postId" value="${post.id}" />
                        <textarea name="content" rows="3" placeholder="Add a comment..."></textarea>
                        <button type="submit" class="btn-submit">Submit Comment</button>
                    </form>
                </div>

                <c:forEach var="comment" items="${comments}">
                    <div class="comment">
                        <div class="comment-header">
                            <strong>${comment.username}</strong>
                            <span>${comment.createdAt}</span>
                        </div>
                        <p class="comment-text">${comment.content}</p>
                    </div>
                </c:forEach>
            </div>
        </body>

        </html>