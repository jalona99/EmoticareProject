<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Create Quiz - EmotiCare Admin</title>
            <style>
                /* Reuse Admin Styles */
                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: #f4f6f9;
                    color: #333;
                    padding: 40px;
                }

                .container {
                    max-width: 600px;
                    margin: 0 auto;
                    background: white;
                    padding: 30px;
                    border-radius: 8px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
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
                input[type="number"] {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                }

                button {
                    padding: 12px 25px;
                    background: #3498db;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                }

                a.cancel {
                    color: #7f8c8d;
                    text-decoration: none;
                    margin-right: 15px;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <h1>Create Quiz for Module</h1>
                <p style="margin-bottom: 20px; color: #7f8c8d;">This module doesn't have a quiz yet. Create one to add
                    questions.</p>

                <form action="${pageContext.request.contextPath}/admin/learning/quiz/create" method="POST">
                    <input type="hidden" name="moduleId" value="${moduleId}">

                    <div class="form-group">
                        <label>Quiz Title</label>
                        <input type="text" name="title" placeholder="e.g. Anxiety Basics Assessment" required>
                    </div>

                    <div class="form-group">
                        <label>Passing Score (%)</label>
                        <input type="number" name="passingScore" value="70" min="0" max="100" required>
                    </div>

                    <div>
                        <a href="${pageContext.request.contextPath}/admin/learning" class="cancel">Cancel</a>
                        <button type="submit">Create Quiz</button>
                    </div>
                </form>
            </div>
        </body>

        </html>