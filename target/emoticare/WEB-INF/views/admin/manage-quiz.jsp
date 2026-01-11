<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Manage Quiz for: ${module.title}</title>
            <style>
                body {
                    font-family: sans-serif;
                    max-width: 800px;
                    margin: 20px auto;
                }

                .section {
                    margin-bottom: 30px;
                    border: 1px solid #ddd;
                    padding: 20px;
                    border-radius: 5px;
                }

                h2 {
                    margin-top: 0;
                }

                .form-row {
                    margin-bottom: 10px;
                }

                label {
                    display: inline-block;
                    width: 150px;
                }

                input[type="text"] {
                    width: 300px;
                }
            </style>
        </head>

        <body>
            <h1>Manage Quiz</h1>
            <h3>Module: ${module.title}</h3>

            <c:if test="${not empty success}">
                <div style="color: green;">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="color: red;">${error}</div>
            </c:if>

            <!-- Quiz Details -->
            <div class="section">
                <h2>Quiz Details</h2>
                <form action="${pageContext.request.contextPath}/admin/learning/quiz/save" method="post">
                    <input type="hidden" name="id" value="${quiz.id}" />
                    <input type="hidden" name="moduleId" value="${module.id}" />

                    <div class="form-row">
                        <label>Quiz Title:</label>
                        <input type="text" name="title" value="${quiz.title}" required />
                    </div>
                    <div class="form-row">
                        <label>Passing Score (%):</label>
                        <input type="number" name="passingScore" value="${quiz.passingScore}" required min="0"
                            max="100" />
                    </div>
                    <button type="submit">Save Quiz Details</button>
                </form>
            </div>

            <!-- Questions List -->
            <c:if test="${quiz.id > 0}">
                <div class="section">
                    <h2>Questions</h2>
                    <ul>
                        <c:forEach var="q" items="${questions}">
                            <li>
                                <strong>${q.questionText}</strong> <br>
                                A: ${q.optionA} | B: ${q.optionB} | C: ${q.optionC} | D: ${q.optionD} <br>
                                Correct: <strong>${q.correctOption}</strong>
                            </li>
                        </c:forEach>
                    </ul>

                    <h3>Add New Question</h3>
                    <form action="${pageContext.request.contextPath}/admin/learning/quiz/question/add" method="post">
                        <input type="hidden" name="quizId" value="${quiz.id}" />

                        <div class="form-row"><label>Question Text:</label><input type="text" name="questionText"
                                required style="width: 100%;" /></div>
                        <div class="form-row"><label>Option A:</label><input type="text" name="optionA" required />
                        </div>
                        <div class="form-row"><label>Option B:</label><input type="text" name="optionB" required />
                        </div>
                        <div class="form-row"><label>Option C:</label><input type="text" name="optionC" required />
                        </div>
                        <div class="form-row"><label>Option D:</label><input type="text" name="optionD" required />
                        </div>
                        <div class="form-row">
                            <label>Correct Option:</label>
                            <select name="correctOption">
                                <option value="A">A</option>
                                <option value="B">B</option>
                                <option value="C">C</option>
                                <option value="D">D</option>
                            </select>
                        </div>
                        <button type="submit">Add Question</button>
                    </form>
                </div>
            </c:if>
            <c:if test="${quiz.id == 0}">
                <p><em>Please save the quiz details first to add questions.</em></p>
            </c:if>

            <p><a href="${pageContext.request.contextPath}/admin/learning">Back to Learning Hub</a></p>
        </body>

        </html>