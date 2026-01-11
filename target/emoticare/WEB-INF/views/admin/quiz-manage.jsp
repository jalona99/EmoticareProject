<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Manage Quiz - EmotiCare Admin</title>
            <style>
                /* Reuse Admin Styles */
                * {
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: #f4f6f9;
                    color: #333;
                    padding: 40px;
                }

                .container {
                    max-width: 900px;
                    margin: 0 auto;
                }

                .card {
                    background: white;
                    padding: 30px;
                    border-radius: 8px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                    margin-bottom: 30px;
                }

                h1,
                h2 {
                    color: #2c3e50;
                    margin-bottom: 20px;
                }

                .form-group {
                    margin-bottom: 15px;
                }

                label {
                    display: block;
                    margin-bottom: 5px;
                    font-weight: 600;
                }

                input[type="text"],
                input[type="number"],
                select {
                    width: 100%;
                    padding: 8px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                }

                .btn {
                    padding: 10px 20px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    color: white;
                    text-decoration: none;
                    display: inline-block;
                }

                .btn-primary {
                    background: #3498db;
                }

                .btn-success {
                    background: #2ecc71;
                }

                .btn-secondary {
                    background: #95a5a6;
                }

                .question-list {
                    list-style: none;
                    padding: 0;
                }

                .question-item {
                    background: #f8f9fa;
                    border: 1px solid #e9ecef;
                    padding: 15px;
                    margin-bottom: 10px;
                    border-radius: 4px;
                }

                .q-header {
                    display: flex;
                    justify-content: space-between;
                    font-weight: bold;
                    margin-bottom: 10px;
                }

                .options {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 10px;
                    font-size: 14px;
                    color: #555;
                }

                .correct {
                    color: #27ae60;
                    font-weight: bold;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <a href="${pageContext.request.contextPath}/admin/learning" class="btn btn-secondary"
                    style="margin-bottom: 20px;">← Back to Modules</a>

                <!-- Quiz Details -->
                <div class="card">
                    <h2>Quiz Settings</h2>
                    <form action="${pageContext.request.contextPath}/admin/learning/quiz/update" method="POST">
                        <input type="hidden" name="id" value="${quiz.id}">
                        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 20px;">
                            <div class="form-group">
                                <label>Title</label>
                                <input type="text" name="title" value="${quiz.title}" required>
                            </div>
                            <div class="form-group">
                                <label>Passing Score (%)</label>
                                <input type="number" name="passingScore" value="${quiz.passingScore}" required>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary">Update Settings</button>
                    </form>
                </div>

                <!-- Question List -->
                <div class="card">
                    <h2>Questions (${questions.size()})</h2>
                    <ul class="question-list">
                        <c:forEach var="q" items="${questions}" varStatus="status">
                            <li class="question-item">
                                <div class="q-header">
                                    <span>${status.count}. ${q.questionText}</span>
                                    <!-- Delete question button could go here -->
                                </div>
                                <div class="options">
                                    <span class="${q.correctOption == 'A' ? 'correct' : ''}">A: ${q.optionA}</span>
                                    <span class="${q.correctOption == 'B' ? 'correct' : ''}">B: ${q.optionB}</span>
                                    <span class="${q.correctOption == 'C' ? 'correct' : ''}">C: ${q.optionC}</span>
                                    <span class="${q.correctOption == 'D' ? 'correct' : ''}">D: ${q.optionD}</span>
                                </div>
                            </li>
                        </c:forEach>
                        <c:if test="${empty questions}">
                            <p>No questions yet.</p>
                        </c:if>
                    </ul>
                </div>

                <!-- Add Question Form -->
                <div class="card">
                    <h2>Add New Question</h2>
                    <form action="${pageContext.request.contextPath}/admin/learning/quiz/question/add" method="POST">
                        <input type="hidden" name="quizId" value="${quiz.id}">

                        <div class="form-group">
                            <label>Question Text</label>
                            <input type="text" name="questionText" required>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                            <div class="form-group"><label>Option A</label><input type="text" name="optionA" required>
                            </div>
                            <div class="form-group"><label>Option B</label><input type="text" name="optionB" required>
                            </div>
                            <div class="form-group"><label>Option C</label><input type="text" name="optionC" required>
                            </div>
                            <div class="form-group"><label>Option D</label><input type="text" name="optionD" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Correct Option</label>
                            <select name="correctOption">
                                <option value="A">Option A</option>
                                <option value="B">Option B</option>
                                <option value="C">Option C</option>
                                <option value="D">Option D</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-success">Add Question</button>
                    </form>
                </div>
            </div>
        </body>

        </html>