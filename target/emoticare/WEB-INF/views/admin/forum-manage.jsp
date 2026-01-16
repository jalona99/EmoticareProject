<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Manage Forum - EmotiCare Admin</title>
            <style>
                /* Reuse Admin Dashboard Styles */
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: #f4f6f9;
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

                .sidebar-menu {
                    list-style: none;
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

                .card {
                    background: white;
                    padding: 30px;
                    border-radius: 8px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                }

                .btn {
                    padding: 8px 15px;
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

                .btn-danger {
                    background: #e74c3c;
                }

                .btn-warning {
                    background: #f39c12;
                }

                .tabs {
                    border-bottom: 2px solid #ecf0f1;
                    margin-bottom: 20px;
                }

                .tab {
                    display: inline-block;
                    padding: 10px 20px;
                    text-decoration: none;
                    color: #7f8c8d;
                    font-weight: 600;
                }

                .tab.active {
                    border-bottom: 2px solid #3498db;
                    color: #3498db;
                    margin-bottom: -2px;
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
                }

                .badge-reported {
                    background: #e74c3c;
                    color: white;
                    padding: 2px 6px;
                    border-radius: 4px;
                    font-size: 11px;
                }

                .badge-deleted {
                    background: #95a5a6;
                    color: white;
                    padding: 2px 6px;
                    border-radius: 4px;
                    font-size: 11px;
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
                        <li><a href="${pageContext.request.contextPath}/admin/forum" class="active">Peer Forum</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/reports">Reporting & Stats</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/badges">Badge Management</a></li>
                    </ul>
                </div>

                <div class="main-content">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 20px;">
                        <h1 style="color: #2c3e50;">Forum Moderation</h1>
                        <a href="${pageContext.request.contextPath}/admin/forum/create" class="btn btn-primary">+ New
                            Announcement</a>
                    </div>

                    <div class="card">
                        <div class="tabs">
                            <a href="?tab=active"
                                class="tab ${empty param.tab || param.tab == 'active' ? 'active' : ''}">Active Posts</a>
                            <a href="?tab=reported" class="tab ${param.tab == 'reported' ? 'active' : ''}">Reported</a>
                            <a href="?tab=deleted" class="tab ${param.tab == 'deleted' ? 'active' : ''}">Deleted
                                History</a>
                        </div>

                        <table>
                            <thead>
                                <tr>
                                    <th>User</th>
                                    <th>Content</th>
                                    <th>Status/Reason</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="post" items="${posts}">
                                    <tr>
                                        <td>
                                            <strong>${post.username}</strong>
                                            <div style="font-size:12px; color:#7f8c8d;">${post.createdAt}</div>
                                        </td>
                                        <td>
                                            <h3>${post.title}</h3>
                                            <p>${post.content.length() > 60 ? post.content.substring(0, 60) :
                                                post.content}...</p>
                                        </td>
                                        <td>
                                            <c:if test="${param.tab == 'reported' || post.reportReason != null}">
                                                <span class="badge-reported">Reported</span><br>
                                                <small style="color:#e74c3c;">Reason: ${post.reportReason}</small>
                                            </c:if>
                                            <c:if test="${param.tab == 'deleted'}">
                                                <span class="badge-deleted">Deleted</span>
                                            </c:if>
                                            <c:if test="${param.tab != 'reported' && param.tab != 'deleted'}">
                                                <small>Active</small>
                                            </c:if>
                                        </td>
                                        <td>
                                            <c:if test="${param.tab != 'deleted'}">
                                                <form action="${pageContext.request.contextPath}/admin/forum/delete"
                                                    method="POST">
                                                    <input type="hidden" name="id" value="${post.id}">
                                                    <button type="submit" class="btn btn-danger"
                                                        onclick="return confirm('Delete this post?')">Delete</button>
                                                </form>
                                            </c:if>
                                            <c:if test="${param.tab == 'deleted'}">
                                                <!-- Optional: Restore button if implemented, or just View -->
                                                <button class="btn" style="background:#bdc3c7; cursor:default;"
                                                    disabled>Deleted</button>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty posts}">
                                    <tr>
                                        <td colspan="4" style="text-align:center; padding: 20px;">No posts found.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </body>

        </html>