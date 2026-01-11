<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Learning Hub - EmotiCare</title>
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
                    max-width: 1200px;
                    margin: 0 auto;
                }

                .header {
                    margin-bottom: 40px;
                    text-align: center;
                }

                .header h1 {
                    font-size: 32px;
                    font-weight: 700;
                    margin-bottom: 10px;
                    color: #fff;
                }

                .back-link {
                    display: inline-block;
                    margin-bottom: 20px;
                    color: #6366f1;
                    text-decoration: none;
                    font-weight: 600;
                }

                .back-link:hover {
                    text-decoration: underline;
                }

                /* Grid Layout */
                .grid-container {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                    gap: 24px;
                }

                /* Card Style */
                .module-card {
                    background: #242838;
                    border: 1px solid #2d3142;
                    border-radius: 16px;
                    padding: 25px;
                    transition: all 0.3s ease;
                    display: flex;
                    flex-direction: column;
                    height: 100%;
                }

                .module-card:hover {
                    border-color: #6366f1;
                    transform: translateY(-4px);
                    box-shadow: 0 12px 24px rgba(99, 102, 241, 0.2);
                }

                .module-title {
                    font-size: 20px;
                    margin-bottom: 12px;
                    color: #fff;
                    font-weight: 700;
                }

                .module-desc {
                    color: #9ca3af;
                    font-size: 14px;
                    line-height: 1.5;
                    margin-bottom: 20px;
                    flex-grow: 1;
                }

                .btn {
                    display: inline-block;
                    padding: 12px 20px;
                    background-color: #6366f1;
                    color: white;
                    text-decoration: none;
                    border-radius: 8px;
                    text-align: center;
                    font-weight: 600;
                    transition: background 0.3s;
                    border: none;
                    cursor: pointer;
                }

                .btn:hover {
                    background-color: #4f46e5;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <a href="${pageContext.request.contextPath}/student/dashboard" class="back-link">← Back to Dashboard</a>

                <div class="header">
                    <h1>Learning Hub</h1>
                    <p style="color: #9ca3af;">Explore resources to support your mental well-being.</p>
                </div>

                <div class="grid-container">
                    <c:forEach var="module" items="${modules}">
                        <div class="module-card">
                            <div class="module-title">${module.title}</div>
                            <div class="module-desc">
                                ${module.description.length() > 120 ? module.description.substring(0, 120) :
                                module.description}${module.description.length() > 120 ? "..." : ""}
                            </div>
                            <a href="${pageContext.request.contextPath}/learning/module/${module.id}" class="btn">Start
                                Module</a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </body>

        </html>