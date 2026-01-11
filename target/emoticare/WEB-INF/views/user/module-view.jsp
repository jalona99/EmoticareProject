<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>${module.title} - EmotiCare Learning</title>
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

                h1 {
                    font-size: 32px;
                    margin-bottom: 30px;
                }

                .content-box {
                    background: #242838;
                    border: 1px solid #2d3142;
                    border-radius: 16px;
                    padding: 30px;
                    margin-bottom: 24px;
                }

                h3 {
                    color: #fff;
                    margin-top: 0;
                    margin-bottom: 16px;
                    font-size: 20px;
                }

                p {
                    color: #d1d5db;
                    line-height: 1.6;
                    margin-bottom: 16px;
                    font-size: 16px;
                }

                .content-link {
                    color: #6366f1;
                    text-decoration: none;
                    font-weight: 600;
                }

                .content-link:hover {
                    text-decoration: underline;
                }

                .status-badge {
                    display: inline-block;
                    padding: 6px 12px;
                    border-radius: 20px;
                    font-size: 14px;
                    font-weight: 600;
                    background: #1a1d2e;
                    color: #9ca3af;
                }

                .status-badge.completed {
                    background: rgba(16, 185, 129, 0.2);
                    color: #10b981;
                }

                .btn-quiz {
                    display: inline-block;
                    padding: 12px 24px;
                    background: #6366f1;
                    color: white;
                    border-radius: 8px;
                    text-decoration: none;
                    font-weight: 600;
                    transition: background 0.2s;
                }

                .btn-quiz:hover {
                    background: #4f46e5;
                }

                .completion-msg {
                    color: #10b981;
                    font-style: italic;
                    font-weight: 500;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <a href="${pageContext.request.contextPath}/learning" class="back-link">← Back to Hub</a>

                <h1>${module.title}</h1>

                <div class="content-box">
                    <h3>Description</h3>
                    <p>${module.description}</p>

                    <c:if test="${not empty module.contentUrl}">
                        <div style="margin-top: 20px;">
                            <h3>Learning Material</h3>
                            <p>
                                <a href="${module.contentUrl}" target="_blank" class="content-link">
                                    📺 Access External Content Material
                                </a>
                            </p>
                        </div>
                    </c:if>
                </div>

                <div class="content-box">
                    <h3>Assessment</h3>
                    <c:if test="${not empty progress}">
                        <div style="margin-bottom: 20px;">
                            <span class="status-badge ${progress.status == 'COMPLETED' ? 'completed' : ''}">
                                Status: ${progress.status}
                                <c:if test="${progress.quizScore != null}"> • Score: ${progress.quizScore}%</c:if>
                            </span>
                        </div>
                    </c:if>

                    <c:if test="${not empty quiz}">
                        <c:choose>
                            <c:when test="${empty progress || progress.status != 'COMPLETED'}">
                                <a href="${pageContext.request.contextPath}/learning/quiz/take/${quiz.id}"
                                    class="btn-quiz">
                                    Take Quiz
                                </a>
                            </c:when>
                            <c:otherwise>
                                <p class="completion-msg">✨ You have successfully completed this module. Great job!</p>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                    <c:if test="${empty quiz}">
                        <p style="color: #9ca3af;">No quiz available for this module yet.</p>
                    </c:if>
                </div>
            </div>
        </body>

        </html>