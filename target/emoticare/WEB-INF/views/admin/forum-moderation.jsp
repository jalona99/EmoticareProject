<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Forum Moderation</title>
            <style>
                body {
                    font-family: sans-serif;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                }

                th,
                td {
                    border: 1px solid #ddd;
                    padding: 8px;
                    text-align: left;
                }

                th {
                    background-color: #f2f2f2;
                }

                .btn-danger {
                    color: white;
                    background-color: #dc3545;
                    padding: 5px 10px;
                    text-decoration: none;
                    border-radius: 4px;
                }
            </style>
        </head>

        <body>
            <h1>Forum Moderation</h1>

            <c:if test="${not empty success}">
                <div style="color: green;">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div style="color: red;">${error}</div>
            </c:if>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>User</th>
                        <th>Title</th>
                        <th>Content Preview</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="post" items="${posts}">
                        <tr>
                            <td>${post.id}</td>
                            <td>${post.username}</td>
                            <td>${post.title}</td>
                            <td>${post.content.length() > 50 ? post.content.substring(0, 50) : post.content}...</td>
                            <td>${post.createdAt}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/forum/delete/${post.id}"
                                    class="btn-danger" onclick="return confirm('Delete this post?')">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <p><a href="${pageContext.request.contextPath}/admin/dashboard">Back to Dashboard</a></p>
        </body>

        </html>

