<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Reporting - EmotiCare Admin</title>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    min-height: 100vh;
                    color: #333;
                }

                .container {
                    display: flex;
                    min-height: 100vh;
                }

                .sidebar {
                    width: 280px;
                    background: #2c3e50;
                    padding: 30px 0;
                    color: white;
                }

                .sidebar-brand {
                    padding: 0 20px 30px;
                    border-bottom: 2px solid #34495e;
                    margin-bottom: 30px;
                }

                .sidebar-brand h2 {
                    font-size: 24px;
                    color: #3498db;
                }

                .sidebar-menu a {
                    display: block;
                    padding: 15px 25px;
                    color: #ecf0f1;
                    text-decoration: none;
                    border-left: 4px solid transparent;
                }

                .sidebar-menu a:hover,
                .sidebar-menu a.active {
                    background: #34495e;
                    border-left-color: #3498db;
                    color: #3498db;
                }

                .main-content {
                    flex: 1;
                    padding: 40px;
                    overflow-y: auto;
                }

                .grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                    gap: 20px;
                    margin-bottom: 40px;
                }

                .card {
                    background: white;
                    padding: 25px;
                    border-radius: 8px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                }

                h2 {
                    color: #2c3e50;
                    margin-bottom: 20px;
                    font-size: 20px;
                    border-bottom: 2px solid #f0f0f0;
                    padding-bottom: 10px;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    font-size: 14px;
                }

                th,
                td {
                    padding: 10px;
                    text-align: left;
                    border-bottom: 1px solid #f0f0f0;
                }

                th {
                    background: #f8f9fa;
                    color: #7f8c8d;
                    font-weight: 600;
                }

                .stat-number {
                    font-size: 36px;
                    font-weight: bold;
                    color: #3498db;
                }

                .stat-label {
                    color: #7f8c8d;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <!-- Sidebar -->
                <div class="sidebar">
                    <div class="sidebar-brand">
                        <h2>Emoticare</h2>
                    </div>
                    <ul class="sidebar-menu">
                        <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/assessments">Assessments</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/users">Users</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/learning">Learning Hub</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/forum">Peer Forum</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/reports" class="active">Reporting &
                                Stats</a></li>
                    </ul>
                </div>

                <div class="main-content">
                    <h1 style="color: white; margin-bottom: 30px;">System Reports & Analytics</h1>

                    <div class="grid">
                        <!-- Module Completions -->
                        <div class="card">
                            <h2>Module Completions</h2>
                            <table>
                                <thead>
                                    <tr>
                                        <th>Module</th>
                                        <th>Completed Users</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="entry" items="${moduleStats}">
                                        <tr>
                                            <td>${entry.key}</td>
                                            <td><strong>${entry.value}</strong></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Recent Badges -->
                        <div class="card">
                            <h2>Badges Earned</h2>
                            <table>
                                <thead>
                                    <tr>
                                        <th>User</th>
                                        <th>Badge</th>
                                        <th>Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="b" items="${userBadges}">
                                        <tr>
                                            <td>${b.username}</td>
                                            <td>${b.badge}</td>
                                            <td>${b.earnedAt.toLocalDate()}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- Forum Stats -->
                        <div class="card">
                            <h2>Forum Activity</h2>
                            <div style="display: flex; justify-content: space-around; text-align: center;">
                                <div>
                                    <div class="stat-number">${forumStats.total_posts}</div>
                                    <div class="stat-label">Posts</div>
                                </div>
                                <div>
                                    <div class="stat-number">${forumStats.total_comments}</div>
                                    <div class="stat-label">Comments</div>
                                </div>
                                <div>
                                    <div class="stat-number">${forumStats.total_likes}</div>
                                    <div class="stat-label">Likes</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Quiz Scores -->
                    <div class="card">
                        <h2>All Quiz Scores</h2>
                        <table>
                            <thead>
                                <tr>
                                    <th>User</th>
                                    <th>Module</th>
                                    <th>Score (%)</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="s" items="${quizScores}">
                                    <tr>
                                        <td>${s.username}</td>
                                        <td>${s.module}</td>
                                        <td>
                                            <span
                                                style="color: ${s.score >= 70 ? '#27ae60' : '#e74c3c'}; font-weight: bold;">
                                                ${s.score}%
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </body>

        </html>