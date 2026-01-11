<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Manage Learning Hub - EmotiCare Admin</title>
            <style>
                /* Reuse Admin Dashboard Styles */
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
                    box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
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

                .sidebar-menu {
                    list-style: none;
                }

                .sidebar-menu a {
                    display: block;
                    padding: 15px 25px;
                    color: #ecf0f1;
                    text-decoration: none;
                    transition: all 0.3s ease;
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

                .header {
                    margin-bottom: 40px;
                }

                .header h1 {
                    color: white;
                    font-size: 36px;
                    margin-bottom: 10px;
                }

                .card {
                    background: white;
                    padding: 30px;
                    border-radius: 8px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                }

                .btn {
                    padding: 10px 20px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    text-decoration: none;
                    display: inline-block;
                    font-weight: 600;
                    color: white;
                }

                .btn-primary {
                    background: #3498db;
                }

                .btn-danger {
                    background: #e74c3c;
                }

                .btn-success {
                    background: #2ecc71;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                }

                th,
                td {
                    padding: 12px;
                    text-align: left;
                    border-bottom: 1px solid #ecf0f1;
                }

                th {
                    background: #f8f9fa;
                    color: #2c3e50;
                }

                tr:hover {
                    background: #f8f9fa;
                }

                .action-links a,
                .action-links button {
                    margin-right: 10px;
                    font-size: 14px;
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
                        <li><a href="${pageContext.request.contextPath}/admin/learning" class="active">Learning Hub</a>
                        </li>
                        <li><a href="${pageContext.request.contextPath}/admin/forum">Peer Forum</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/reports">Reporting & Stats</a></li>
                    </ul>
                </div>

                <!-- Main Content -->
                <div class="main-content">
                    <div class="header">
                        <h1>Manage Learning Modules</h1>
                        <p style="color: rgba(255,255,255,0.8)">Create, update, and remove learning content.</p>
                    </div>

                    <div class="card">
                        <div
                            style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                            <h2>All Modules</h2>
                            <a href="${pageContext.request.contextPath}/admin/learning/create" class="btn btn-primary">+
                                Add New Module</a>
                        </div>

                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Title</th>
                                    <th>Description</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="module" items="${modules}">
                                    <tr>
                                        <td>${module.id}</td>
                                        <td><strong>${module.title}</strong></td>
                                        <td>${module.description.length() > 50 ? module.description.substring(0, 50) :
                                            module.description}...</td>
                                        <td class="action-links">
                                            <a href="${pageContext.request.contextPath}/admin/learning/quiz/${module.id}"
                                                class="btn btn-primary"
                                                style="padding: 5px 10px; background: #9b59b6;">Quiz</a>
                                            <a href="${pageContext.request.contextPath}/admin/learning/edit/${module.id}"
                                                class="btn btn-success" style="padding: 5px 10px;">Edit</a>
                                            <form action="${pageContext.request.contextPath}/admin/learning/delete"
                                                method="POST" style="display:inline;">
                                                <input type="hidden" name="id" value="${module.id}">
                                                <button type="submit" class="btn btn-danger" style="padding: 5px 10px;"
                                                    onclick="return confirm('Are you sure?')">Delete</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty modules}">
                                    <tr>
                                        <td colspan="4" style="text-align:center; padding: 20px;">No modules found.
                                            Create one to get started!</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </body>

        </html>