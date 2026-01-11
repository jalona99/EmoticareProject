<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Create Forum Post - Emoticare Admin</title>
            <style>
                /* Reuse Admin Styles */
                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: #f4f6f9;
                    color: #333;
                    padding: 40px;
                }

                .card {
                    background: white;
                    padding: 30px;
                    border-radius: 8px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                    max-width: 600px;
                    margin: 0 auto;
                }

                h1 {
                    margin-bottom: 20px;
                    color: #2c3e50;
                }

                .form-group {
                    margin-bottom: 20px;
                }

                label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: 600;
                }

                input[type="text"],
                textarea {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    font-size: 16px;
                }

                textarea {
                    height: 150px;
                    resize: vertical;
                }

                .btn {
                    padding: 12px 24px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    color: white;
                    background: #3498db;
                    font-size: 16px;
                    width: 100%;
                }

                .btn:hover {
                    background: #2980b9;
                }

                .btn-back {
                    background: #95a5a6;
                    display: inline-block;
                    width: auto;
                    text-decoration: none;
                    margin-bottom: 20px;
                }
            </style>
        </head>

        <body>

            <a href="${pageContext.request.contextPath}/admin/forum" class="btn btn-back">← Back to Moderators</a>

            <div class="card">
                <h1>Create Admin Post</h1>
                <form action="${pageContext.request.contextPath}/admin/forum/create" method="POST">
                    <div class="form-group">
                        <label>Title</label>
                        <input type="text" name="title" required placeholder="Important Announcement...">
                    </div>

                    <div class="form-group">
                        <label>Content</label>
                        <textarea name="content" required placeholder="Write your message here..."></textarea>
                    </div>

                    <button type="submit" class="btn">Post Announcement</button>
                </form>
            </div>

        </body>

        </html>