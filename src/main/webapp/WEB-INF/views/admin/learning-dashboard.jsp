<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin - Learning Hub Management</title>
    <!-- Add your CSS links here -->
    <style>
        body { font-family: sans-serif; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .btn { padding: 5px 10px; text-decoration: none; color: white; border-radius: 4px; }
        .btn-primary { background-color: #007bff; }
        .btn-danger { background-color: #dc3545; }
        .btn-success { background-color: #28a745; }
        .action-links a { margin-right: 10px; }
    </style>
</head>
<body>
    <h1>Learning Hub Management</h1>
    
    <c:if test="${not empty success}">
        <div style="color: green;">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div style="color: red;">${error}</div>
    </c:if>

    <div>
        <a href="${pageContext.request.contextPath}/admin/learning/module/new" class="btn btn-primary">Add New Module</a>
    </div>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Title</th>
                <th>Description</th>
                <th>Content URL</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="module" items="${modules}">
                <tr>
                    <td>${module.id}</td>
                    <td>${module.title}</td>
                    <td>${module.description}</td>
                    <td><a href="${module.contentUrl}" target="_blank">View Content</a></td>
                    <td class="action-links">
                        <a href="${pageContext.request.contextPath}/admin/learning/module/edit/${module.id}" class="btn btn-primary">Edit</a>
                        <a href="${pageContext.request.contextPath}/admin/learning/quiz/manage/${module.id}" class="btn btn-success">Manage Quiz</a>
                        <a href="${pageContext.request.contextPath}/admin/learning/module/delete/${module.id}" class="btn btn-danger" onclick="return confirm('Are you sure?')">Delete</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    
    <div style="margin-top: 20px;">
        <a href="${pageContext.request.contextPath}/dashboard">Back to Dashboard</a>
    </div>
</body>
</html>
