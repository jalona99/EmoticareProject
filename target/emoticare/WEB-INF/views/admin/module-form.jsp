<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>${isEdit ? 'Edit' : 'Create'} Module - EmotiCare Admin</title>
            <style>
                /* Shared Styles */
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
                }

                .card {
                    background: white;
                    padding: 30px;
                    border-radius: 8px;
                    max-width: 800px;
                    margin: 0 auto;
                }

                .form-group {
                    margin-bottom: 20px;
                }

                label {
                    display: block;
                    margin-bottom: 8px;
                    font-weight: 600;
                    color: #2c3e50;
                }

                input[type="text"],
                textarea {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                    font-size: 16px;
                    font-family: inherit;
                }

                textarea {
                    height: 150px;
                    resize: vertical;
                }

                button {
                    padding: 12px 25px;
                    background: #3498db;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 16px;
                }

                button:hover {
                    background: #2980b9;
                }

                .btn-cancel {
                    background: #95a5a6;
                    text-decoration: none;
                    padding: 12px 25px;
                    border-radius: 4px;
                    color: white;
                    display: inline-block;
                    margin-right: 10px;
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
                    </ul>
                </div>

                <div class="main-content">
                    <div class="card">
                        <h2 style="margin-bottom: 20px;">${isEdit ? 'Edit' : 'Create New'} Module</h2>

                        <form action="${pageContext.request.contextPath}/admin/learning/${isEdit ? 'update' : 'create'}"
                            method="POST">
                            <c:if test="${isEdit}">
                                <input type="hidden" name="id" value="${module.id}">
                            </c:if>

                            <div class="form-group">
                                <label>Title</label>
                                <input type="text" name="title" value="${module.title}" required>
                            </div>

                            <div class="form-group">
                                <label>Description</label>
                                <textarea name="description" required>${module.description}</textarea>
                            </div>

                            <div class="form-group">
                                <label>Content URL (External Link)</label>
                                <input type="text" name="contentUrl" value="${module.contentUrl}"
                                    placeholder="https://...">
                            </div>

                            <div style="margin-top: 30px;">
                                <a href="${pageContext.request.contextPath}/admin/learning"
                                    class="btn-cancel">Cancel</a>
                                <button type="submit">${isEdit ? 'Update Module' : 'Create Module'}</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </body>

        </html>