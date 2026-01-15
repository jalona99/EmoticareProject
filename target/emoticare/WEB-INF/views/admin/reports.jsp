<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Admin Reports</title>
            <style>
                body {
                    font-family: sans-serif;
                }

                .stat-box {
                    border: 1px solid #ccc;
                    padding: 15px;
                    display: inline-block;
                    margin-right: 20px;
                    background-color: #f9f9f9;
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
            </style>
        </head>

        <body>
            <h1>System Reports</h1>

            <div class="stat-box">
                <h3>Total Users</h3>
                <p style="font-size: 24px; font-weight: bold;">${totalUsers}</p>
            </div>

            <h2>User Activity</h2>
            <table>
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Role ID</th>
                        <th>Status</th>
                        <th>Detail</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>${user.id}</td>
                            <td>${user.username}</td>
                            <td>${user.email}</td>
                            <td>${user.roleId}</td>
                            <td>${user.active ? 'Active' : 'Inactive'}</td>
                            <td>
                                <!-- In a full implementation, link to individual user progress report -->
                                View Progress (Not Implemented)
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <p><a href="${pageContext.request.contextPath}/admin/dashboard">Back to Dashboard</a></p>
        </body>

        </html>

