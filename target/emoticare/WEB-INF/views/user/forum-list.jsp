<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Community Forum - EmotiCare</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
            <style>
                /* Shared Dashboard Theme */
                body {
                    font-family: 'Inter', sans-serif;
                    background: #1a1d2e;
                    color: #ffffff;
                    margin: 0;
                    padding: 40px 20px;
                    min-height: 100vh;
                }

                .container {
                    max-width: 900px;
                    margin: 0 auto;
                }

                .header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 30px;
                }

                .header h1 {
                    font-size: 28px;
                    font-weight: 700;
                    margin: 0;
                }

                .back-link {
                    color: #6366f1;
                    text-decoration: none;
                    font-weight: 600;
                }

                .back-link:hover {
                    text-decoration: underline;
                }

                /* Create Post Form */
                .create-form {
                    background: #242838;
                    border: 1px solid #2d3142;
                    border-radius: 16px;
                    padding: 24px;
                    margin-bottom: 40px;
                }

                .create-form h3 {
                    margin-top: 0;
                    margin-bottom: 16px;
                    font-size: 18px;
                }

                .form-group {
                    margin-bottom: 15px;
                }

                input[type="text"],
                textarea {
                    width: 100%;
                    padding: 12px 16px;
                    background: #1a1d2e;
                    border: 1px solid #2d3142;
                    border-radius: 8px;
                    color: white;
                    font-family: inherit;
                    box-sizing: border-box;
                }

                input[type="text"]:focus,
                textarea:focus {
                    outline: none;
                    border-color: #6366f1;
                }

                button {
                    padding: 10px 20px;
                    background-color: #6366f1;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    cursor: pointer;
                    font-weight: 600;
                    transition: background 0.2s;
                }

                button:hover {
                    background-color: #4f46e5;
                }

                /* Post List */
                .section-title {
                    font-size: 20px;
                    margin-bottom: 20px;
                    color: #9ca3af;
                    text-transform: uppercase;
                    letter-spacing: 1px;
                    font-size: 14px;
                    font-weight: 600;
                }

                .post-card {
                    background: #242838;
                    border: 1px solid #2d3142;
                    border-radius: 12px;
                    padding: 24px;
                    margin-bottom: 16px;
                    transition: all 0.2s ease;
                }

                .post-card:hover {
                    border-color: #6366f1;
                    transform: translateY(-2px);
                }

                .post-title a {
                    font-size: 18px;
                    color: #fff;
                    text-decoration: none;
                    font-weight: 700;
                }

                .post-title a:hover {
                    color: #6366f1;
                }

                .post-meta {
                    font-size: 13px;
                    color: #9ca3af;
                    margin: 8px 0 12px 0;
                }

                .post-excerpt {
                    color: #d1d5db;
                    line-height: 1.5;
                    font-size: 15px;
                }

                .stats-pill {
                    display: inline-block;
                    background: #1a1d2e;
                    padding: 4px 10px;
                    border-radius: 12px;
                    font-size: 12px;
                    color: #6366f1;
                    margin-left: 8px;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="header">
                    <h1>Community Forum</h1>
                    <a href="${pageContext.request.contextPath}/student/dashboard" class="back-link">Back to
                        Dashboard</a>
                </div>

                <div class="create-form">
                    <h3>Start a Discussion</h3>
                    <form action="${pageContext.request.contextPath}/forum/post/create" method="post">
                        <div class="form-group">
                            <input type="text" name="title" placeholder="What's on your mind? (Title)" required />
                        </div>
                        <div class="form-group">
                            <textarea name="content" rows="3" placeholder="Share your experience or ask a question..."
                                required></textarea>
                        </div>
                        <button type="submit">Post Discussion</button>
                    </form>
                </div>

                <div class="section-title">Recent Discussions</div>

                <c:forEach var="post" items="${posts}">
                    <div class="post-card">
                        <div class="post-title">
                            <a href="${pageContext.request.contextPath}/forum/post/${post.id}">${post.title}</a>
                        </div>
                        <div class="post-meta">
                            Posted by <strong>${post.username}</strong> on ${post.createdAt}
                            <span class="stats-pill">💬 ${post.commentCount} Comments</span>
                            <span class="stats-pill">❤️ ${post.likeCount} Likes</span>
                        </div>
                        <div class="post-excerpt">
                            ${post.content.length() > 200 ? post.content.substring(0, 200) :
                            post.content}${post.content.length() > 200 ? "..." : ""}
                        </div>
                        <div style="margin-top: 10px; text-align: right;">
                            <form action="${pageContext.request.contextPath}/forum/post/report" method="post"
                                style="display:inline;" onsubmit="return promptReason(this);">
                                <input type="hidden" name="postId" value="${post.id}">
                                <input type="hidden" name="reason" class="reason-input">
                                <button type="submit"
                                    style="background:none; border:none; color:#ef4444; font-size:12px; cursor:pointer; padding:0;">🚩
                                    Report</button>
                            </form>
                        </div>
                    </div>
                </c:forEach>

                <script>
                    function promptReason(form) {
                        const reason = prompt("Why are you reporting this post?");
                        if (reason) {
                            form.querySelector('.reason-input').value = reason;
                            return true;
                        }
                        return false;
                    }
                </script>
            </div>
        </body>

        </html>