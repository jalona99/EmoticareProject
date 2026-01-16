<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Manage Badges - Emoticare Admin</title>
            <style>
                /* Reuse Admin Styles */
                * {
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background: #f4f6f9;
                    color: #333;
                    padding: 40px;
                }

                /* Add Sidebar styles here or link external css if available. Simplified for this file. */

                .container {
                    max-width: 1000px;
                    margin: 0 auto;
                    display: flex;
                    gap: 30px;
                }

                .main-content {
                    flex: 1;
                }

                .card {
                    background: white;
                    padding: 30px;
                    border-radius: 8px;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                    margin-bottom: 30px;
                }

                h1,
                h2 {
                    color: #2c3e50;
                    margin-bottom: 20px;
                }

                .form-group {
                    margin-bottom: 15px;
                }

                label {
                    display: block;
                    margin-bottom: 5px;
                    font-weight: 600;
                }

                input[type="text"],
                select,
                textarea {
                    width: 100%;
                    padding: 8px;
                    border: 1px solid #ddd;
                    border-radius: 4px;
                }

                .btn {
                    padding: 10px 20px;
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

                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                }

                th,
                td {
                    padding: 12px;
                    text-align: left;
                    border-bottom: 1px solid #eee;
                }

                th {
                    background: #f8f9fa;
                    font-weight: 600;
                    color: #7f8c8d;
                }
            </style>
        </head>

        <body>
            <div style="margin-bottom: 20px;">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary"
                    style="background: #95a5a6;">← Back to Dashboard</a>
            </div>

            <div class="card">
                <h1>Badge Management</h1>
                <p style="color: #7f8c8d;">Define badges that users can earn. Badges linked to a module are awarded
                    automatically upon completion.</p>

                <!-- List Badges -->
                <table>
                    <thead>
                        <tr>
                            <th>Icon</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Criteria (Module)</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="badge" items="${badges}">
                            <tr>
                                <td>
                                    <c:if test="${not empty badge.iconUrl}">
                                        <img src="${badge.iconUrl}" alt="icon" style="width: 30px; height: 30px;">
                                    </c:if>
                                </td>
                                <td><strong>${badge.name}</strong></td>
                                <td>${badge.description}</td>
                                <td>
                                    <c:if test="${not empty badge.criteriaModuleId}">
                                        Module ID: ${badge.criteriaModuleId}
                                    </c:if>
                                    <c:if test="${empty badge.criteriaModuleId}">
                                        <em>None (Manual)</em>
                                    </c:if>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/badges/delete" method="POST"
                                        onsubmit="return confirm('Delete this badge?');">
                                        <input type="hidden" name="id" value="${badge.id}">
                                        <button type="submit" class="btn btn-danger"
                                            style="padding: 5px 10px; font-size: 12px;">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty badges}">
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 20px;">No badges defined yet.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

            <!-- Create Badge Form -->
            <div class="card">
                <h2>Create New Badge</h2>
                <form action="${pageContext.request.contextPath}/admin/badges/create" method="POST">
                    <div class="form-group">
                        <label>Badge Name</label>
                        <input type="text" name="name" required placeholder="e.g. Anxiety Warrior">
                    </div>

                    <div class="form-group">
                        <label>Description</label>
                        <textarea name="description" required placeholder="Description of achievement..."></textarea>
                    </div>

                    <div class="form-group">
                        <label>Icon URL (Emoji or Image Link)</label>
                        <input type="text" name="iconUrl" placeholder="e.g. 🏆 or https://example.com/badge.png">
                    </div>

                    <div class="form-group">
                        <label>Award Criteria (Optional)</label>
                        <p style="font-size: 12px; color: #666; margin-bottom: 5px;">Select a module to automatically
                            award this badge when completed.</p>
                        <select name="criteriaModuleId">
                            <option value="">-- None (Manual Award Only) --</option>
                            <c:forEach var="m" items="${modules}">
                                <option value="${m.id}">${m.title}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary">Create Badge</button>
                </form>
            </div>

        </body>

        </html>