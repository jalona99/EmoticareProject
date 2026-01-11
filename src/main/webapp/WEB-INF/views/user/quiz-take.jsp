<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Take Quiz - EmotiCare</title>
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
                    max-width: 700px;
                    margin: 0 auto;
                }

                h1 {
                    text-align: center;
                    margin-bottom: 40px;
                    font-size: 28px;
                }

                .quiz-card {
                    background: #242838;
                    border: 1px solid #2d3142;
                    border-radius: 16px;
                    padding: 30px;
                }

                .question {
                    margin-bottom: 30px;
                    padding-bottom: 30px;
                    border-bottom: 1px solid #2d3142;
                }

                .question:last-child {
                    border-bottom: none;
                }

                .question-text {
                    font-size: 18px;
                    font-weight: 600;
                    margin-bottom: 16px;
                    color: #fff;
                }

                label {
                    display: block;
                    margin-bottom: 12px;
                    padding: 12px 16px;
                    background: #1a1d2e;
                    border: 1px solid #2d3142;
                    border-radius: 8px;
                    cursor: pointer;
                    transition: all 0.2s;
                }

                label:hover {
                    border-color: #6366f1;
                    background: rgba(99, 102, 241, 0.1);
                }

                input[type="radio"] {
                    margin-right: 12px;
                    transform: scale(1.2);
                    accent-color: #6366f1;
                }

                .btn-submit {
                    display: block;
                    width: 100%;
                    padding: 14px;
                    background: #6366f1;
                    color: white;
                    border: none;
                    border-radius: 8px;
                    font-size: 16px;
                    font-weight: 700;
                    cursor: pointer;
                    transition: background 0.3s;
                    margin-top: 20px;
                }

                .btn-submit:hover {
                    background: #4f46e5;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <h1>Quiz Time! 🧠</h1>

                <div class="quiz-card">
                    <form action="${pageContext.request.contextPath}/learning/quiz/submit" method="post">
                        <input type="hidden" name="quizId" value="${quizId}" />
                        <input type="hidden" name="moduleId" value="${quiz.moduleId}" />

                        <c:forEach var="q" items="${questions}" varStatus="status">
                            <div class="question">
                                <div class="question-text">${status.count}. ${q.questionText}</div>
                                <label><input type="radio" name="question_${q.id}" value="A" required>
                                    ${q.optionA}</label>
                                <label><input type="radio" name="question_${q.id}" value="B"> ${q.optionB}</label>
                                <label><input type="radio" name="question_${q.id}" value="C"> ${q.optionC}</label>
                                <label><input type="radio" name="question_${q.id}" value="D"> ${q.optionD}</label>
                            </div>
                        </c:forEach>

                        <button type="submit" class="btn-submit">Submit Answers</button>
                    </form>
                </div>
            </div>
        </body>

        </html>