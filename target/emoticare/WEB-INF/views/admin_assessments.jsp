<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Manage Assessments - EmotiCare Admin</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Inter', sans-serif;
                    background: #1a1d2e;
                    color: #ffffff;
                    min-height: 100vh;
                    padding: 24px;
                }

                .container {
                    max-width: 1400px;
                    margin: 0 auto;
                }

                .header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 32px;
                }

                h1 {
                    font-size: 32px;
                    font-weight: 700;
                }

                .subtitle {
                    color: #9ca3af;
                    margin-top: 8px;
                }

                .stats {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                    gap: 16px;
                    margin-bottom: 32px;
                }

                .stat-card {
                    background: #242838;
                    padding: 20px;
                    border-radius: 12px;
                    border: 1px solid #2d3142;
                }

                .stat-label {
                    color: #9ca3af;
                    font-size: 12px;
                    text-transform: uppercase;
                }

                .stat-value {
                    font-size: 28px;
                    font-weight: 700;
                    margin-top: 8px;
                }

                .filters {
                    display: flex;
                    gap: 12px;
                    margin-bottom: 24px;
                    flex-wrap: wrap;
                }

                .filter-select,
                .filter-input {
                    padding: 10px 16px;
                    border: 1px solid #2d3142;
                    border-radius: 8px;
                    background: #242838;
                    color: #ffffff;
                    font-size: 14px;
                }

                .filter-select:focus,
                .filter-input:focus {
                    outline: none;
                    border-color: #6366f1;
                }

                .btn {
                    padding: 10px 20px;
                    border: none;
                    border-radius: 8px;
                    cursor: pointer;
                    font-weight: 600;
                    transition: all 0.2s ease;
                }

                .btn-primary {
                    background: #6366f1;
                    color: #ffffff;
                }

                .btn-primary:hover {
                    background: #4f46e5;
                }

                .btn-secondary {
                    background: #2d3142;
                    color: #ffffff;
                }

                .btn-secondary:hover {
                    background: #3d4152;
                }

                .table-container {
                    background: #242838;
                    border-radius: 12px;
                    border: 1px solid #2d3142;
                    overflow: hidden;
                }

                table {
                    width: 100%;
                    border-collapse: collapse;
                }

                th {
                    background: #1a1d2e;
                    padding: 16px;
                    text-align: left;
                    font-weight: 600;
                    font-size: 13px;
                    text-transform: uppercase;
                    color: #9ca3af;
                    border-bottom: 1px solid #2d3142;
                }

                td {
                    padding: 16px;
                    border-bottom: 1px solid #2d3142;
                    font-size: 14px;
                }

                tr:last-child td {
                    border-bottom: none;
                }

                tr:hover {
                    background: #2d3142;
                }

                .status-badge {
                    display: inline-block;
                    padding: 4px 12px;
                    border-radius: 12px;
                    font-size: 12px;
                    font-weight: 600;
                }

                .status-COMPLETED {
                    background: #10b981;
                    color: #fff;
                }

                .status-IN_PROGRESS {
                    background: #f59e0b;
                    color: #fff;
                }

                .status-DRAFT {
                    background: #6b7280;
                    color: #fff;
                }

                .risk-CRITICAL {
                    color: #ef4444;
                    font-weight: 600;
                }

                .risk-HIGH {
                    color: #ef4444;
                    font-weight: 600;
                }

                .risk-MODERATE {
                    color: #f59e0b;
                    font-weight: 600;
                }

                .risk-LOW {
                    color: #10b981;
                    font-weight: 600;
                }

                .actions {
                    display: flex;
                    gap: 8px;
                }

                .action-btn {
                    padding: 6px 12px;
                    border: none;
                    border-radius: 6px;
                    font-size: 12px;
                    cursor: pointer;
                    background: #6366f1;
                    color: #fff;
                    text-decoration: none;
                    transition: all 0.2s ease;
                }

                .action-btn:hover {
                    background: #4f46e5;
                }

                .empty-state {
                    padding: 48px;
                    text-align: center;
                    color: #9ca3af;
                }

                .empty-state h3 {
                    font-size: 18px;
                    margin-bottom: 12px;
                }

                a {
                    color: #6366f1;
                    text-decoration: none;
                }

                a:hover {
                    color: #4f46e5;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <div class="header">
                    <div>
                        <h1>📊 Assessment Management</h1>
                        <p class="subtitle">Welcome, <strong>${username}</strong></p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-secondary">← Back to
                        Dashboard</a>
                </div>

                <!-- Statistics -->
                <div class="stats">
                    <div class="stat-card">
                        <div class="stat-label">Total Assessments</div>
                        <div class="stat-value">${totalAssessments}</div>
                    </div>
                    <c:forEach var="entry" items="${riskLevelStats}">
                        <div class="stat-card">
                            <div class="stat-label">Risk: ${entry.key}</div>
                            <div class="stat-value">${entry.value}</div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Assessment Type Management -->
                <h2 style="font-size: 20px; margin-bottom: 20px;">📂 Managed Question Banks</h2>
                <div class="stats" style="margin-bottom: 48px;">
                    <c:forEach var="type" items="${assessmentTypes}">
                        <div class="stat-card"
                            style="display: flex; flex-direction: column; justify-content: space-between;">
                            <div>
                                <div class="stat-label">${type.code}</div>
                                <div class="stat-value" style="font-size: 20px; margin-bottom: 12px;">${type.name}</div>
                            </div>
                            <a href="${pageContext.request.contextPath}/admin/assessments/questions/type/${type.id}"
                                class="action-btn" style="text-align: center; display: block;">⚙️ Manage Questions</a>
                        </div>
                    </c:forEach>
                </div>

                <h2 style="font-size: 20px; margin-bottom: 20px;">📈 Student Submissions</h2>
                <!-- Filters -->
                <div class="filters">
                    <form method="get" action="${pageContext.request.contextPath}/admin/assessments"
                        style="display: flex; gap: 12px; align-items: center;">
                        <select name="status" class="filter-select">
                            <option value="">📋 All Statuses</option>
                            <option value="DRAFT" ${selectedStatus eq 'DRAFT' ? 'selected' : '' }>Draft</option>
                            <option value="IN_PROGRESS" ${selectedStatus eq 'IN_PROGRESS' ? 'selected' : '' }>In
                                Progress</option>
                            <option value="COMPLETED" ${selectedStatus eq 'COMPLETED' ? 'selected' : '' }>Completed
                            </option>
                        </select>

                        <select name="typeId" class="filter-select">
                            <option value="">📝 All Types</option>
                            <c:forEach var="type" items="${assessmentTypes}">
                                <option value="${type.id}" ${selectedTypeId eq type.id ? 'selected' : '' }>${type.name}
                                </option>
                            </c:forEach>
                        </select>

                        <button type="submit" class="btn btn-primary">🔍 Filter</button>
                    </form>
                </div>

                <!-- Table -->
                <c:choose>
                    <c:when test="${not empty assessments}">
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Assessment ID</th>
                                        <th>User ID</th>
                                        <th>Assessment Type</th>
                                        <th>Status</th>
                                        <th>Score</th>
                                        <th>Risk Level</th>
                                        <th>Started At</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="assessment" items="${assessments}">
                                        <tr>
                                            <td><strong>#${assessment.id}</strong></td>
                                            <td>${assessment.userId}</td>
                                            <td>${assessment.assessmentTypeId}</td>
                                            <td>
                                                <span class="status-badge status-${assessment.status}">
                                                    ${assessment.status}
                                                </span>
                                            </td>
                                            <td>${assessment.totalScore > 0 ? assessment.totalScore : '—'}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${assessment.riskLevel != null}">
                                                        <span
                                                            class="risk-${assessment.riskLevel}">${assessment.riskLevel}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span style="color: #6b7280;">—</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${assessment.startedAt}</td>
                                            <td>
                                                <div class="actions">
                                                    <a href="${pageContext.request.contextPath}/admin/assessments/${assessment.id}"
                                                        class="action-btn">👁️ View</a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-state">
                            <h3>📭 No assessments found</h3>
                            <p>Try adjusting your filters or check back later.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </body>

        </html>