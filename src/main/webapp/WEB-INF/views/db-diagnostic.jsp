<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Database Diagnostic</title>
            <style>
                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: #f0f2f5;
                    padding: 40px;
                    color: #333;
                }

                .card {
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                    max-width: 600px;
                    margin: 0 auto;
                    padding: 30px;
                }

                .success {
                    color: #10b981;
                    font-weight: bold;
                }

                .error {
                    color: #ef4444;
                    font-weight: bold;
                }

                .item {
                    margin-bottom: 15px;
                    border-bottom: 1px solid #eee;
                    padding-bottom: 10px;
                }

                .label {
                    color: #6b7280;
                    font-size: 0.875rem;
                    display: block;
                }

                .value {
                    font-family: monospace;
                    font-size: 1rem;
                    color: #111827;
                }

                h1 {
                    margin-top: 0;
                    font-size: 1.5rem;
                    text-align: center;
                }
            </style>
        </head>

        <body>
            <div class="card">
                <h1>Database Connection Diagnostic</h1>

                <div class="item">
                    <span class="label">Status</span>
                    <span class="value ${status == 'SUCCESS' ? 'success' : 'error'}">${status}</span>
                </div>

                <c:if test="${status == 'SUCCESS'}">
                    <div class="item">
                        <span class="label">Database Product</span>
                        <span class="value">${database}</span>
                    </div>
                    <div class="item">
                        <span class="label">Version</span>
                        <span class="value">${version}</span>
                    </div>
                    <div class="item">
                        <span class="label">User</span>
                        <span class="value">${user}</span>
                    </div>
                    <div class="item">
                        <span class="label">URL</span>
                        <span class="value">${url}</span>
                    </div>
                </c:if>

                <c:if test="${status != 'SUCCESS'}">
                    <div class="item">
                        <span class="label">Error Detail</span>
                        <span class="value error">${error}</span>
                    </div>
                </c:if>

                <div style="text-align: center; margin-top: 20px;">
                    <a href="${pageContext.request.contextPath}/login" style="color: #6366f1; text-decoration: none;">←
                        Go to Login</a>
                </div>
            </div>
        </body>

        </html>