<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Emoticare</title>
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
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
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

        .sidebar-menu li {
            margin: 0;
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

        .sidebar-user {
            padding: 20px 25px;
            border-top: 2px solid #34495e;
            margin-top: auto;
        }

        .sidebar-user p {
            color: #bdc3c7;
            font-size: 12px;
            margin-bottom: 10px;
        }

        .sidebar-user strong {
            color: #ecf0f1;
            display: block;
            margin-bottom: 15px;
        }

        .logout-btn {
            width: 100%;
            padding: 10px;
            background: #e74c3c;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.3s ease;
            text-decoration: none;
            text-align: center;
            display: inline-block;
        }

        .logout-btn:hover {
            background: #c0392b;
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

        .header p {
            color: rgba(255,255,255,0.8);
            font-size: 14px;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .card-icon {
            font-size: 36px;
            margin-bottom: 15px;
        }

        .card-icon.assessments { color: #3498db; }
        .card-icon.users { color: #2ecc71; }
        .card-icon.risk { color: #e74c3c; }
        .card-icon.completed { color: #f39c12; }

        .card h3 {
            color: #2c3e50;
            font-size: 14px;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .card-value {
            font-size: 32px;
            font-weight: bold;
            color: #2c3e50;
        }

        .card-footer {
            font-size: 12px;
            color: #7f8c8d;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #ecf0f1;
        }

        .card-link {
            color: #3498db;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .card-link:hover {
            color: #2980b9;
        }

        .section {
            background: white;
            padding: 30px;
            border-radius: 8px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .section h2 {
            color: #2c3e50;
            font-size: 20px;
            margin-bottom: 20px;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 25px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            font-size: 14px;
            font-weight: 600;
        }

        .btn-primary {
            background: #3498db;
            color: white;
        }

        .btn-primary:hover {
            background: #2980b9;
        }

        .btn-secondary {
            background: #95a5a6;
            color: white;
        }

        .btn-secondary:hover {
            background: #7f8c8d;
        }

        .btn-success {
            background: #2ecc71;
            color: white;
        }

        .btn-success:hover {
            background: #27ae60;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        table thead {
            background: #ecf0f1;
        }

        table th {
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #bdc3c7;
        }

        table td {
            padding: 12px;
            border-bottom: 1px solid #ecf0f1;
        }

        table tr:hover {
            background: #f8f9fa;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-completed {
            background: #d4edda;
            color: #155724;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-in-progress {
            background: #d1ecf1;
            color: #0c5460;
        }

        .alert {
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }

        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .no-data {
            text-align: center;
            color: #7f8c8d;
            padding: 40px 20px;
        }

        .risk-high { background: #e74c3c; color: white; }
        .risk-medium { background: #f39c12; color: white; }
        .risk-low { background: #2ecc71; color: white; }

        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                padding: 15px 0;
            }

            .sidebar-brand {
                padding: 0 15px 15px;
            }

            .sidebar-menu a {
                padding: 10px 15px;
            }

            .main-content {
                padding: 20px;
            }

            .header h1 {
                font-size: 24px;
            }

            .dashboard-grid {
                grid-template-columns: 1fr;
            }
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
                <li>
                    <a href="/emoticare/admin/dashboard" class="active">Dashboard</a>
                </li>
                <li>
                    <a href="/emoticare/admin/assessments">Assessments</a>
                </li>
                <li>
                    <a href="/emoticare/admin/users">Users</a>
                </li>
            </ul>
            <div class="sidebar-user">
                <p>Logged in as:</p>
                <strong>${username != null ? username : 'Admin'}</strong>
                <form action="/emoticare/logout" method="POST" style="display: inline; width: 100%;">
                    <button type="submit" class="logout-btn">Logout</button>
                </form>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <h1>Admin Dashboard</h1>
                <p>Welcome back! Here's an overview of your system.</p>
            </div>

            <!-- Statistics Cards -->
            <div class="dashboard-grid">
                <!-- Total Assessments Card -->
                <div class="card">
                    <div class="card-icon assessments">📋</div>
                    <h3>Total Assessments</h3>
                    <div class="card-value">${totalAssessments != null ? totalAssessments : 0}</div>
                    <div class="card-footer">
                        <a href="/emoticare/admin/assessments" class="card-link">View all →</a>
                    </div>
                </div>

                <!-- Total Users Card -->
                <div class="card">
                    <div class="card-icon users">👥</div>
                    <h3>Total Users</h3>
                    <div class="card-value">${totalUsers != null ? totalUsers : 0}</div>
                    <div class="card-footer">
                        <a href="/emoticare/admin/users" class="card-link">Manage users →</a>
                    </div>
                </div>

                <!-- High Risk Card -->
                <div class="card">
                    <div class="card-icon risk">⚠️</div>
                    <h3>High Risk Cases</h3>
                    <div class="card-value">${riskStats != null && riskStats['HIGH'] != null ? riskStats['HIGH'] : 0}</div>
                    <div class="card-footer">
                        <a href="/emoticare/admin/assessments?status=COMPLETED" class="card-link">Review cases →</a>
                    </div>
                </div>

                <!-- Completed Assessments Card -->
                <div class="card">
                    <div class="card-icon completed">✓</div>
                    <h3>Completed Today</h3>
                    <div class="card-value">${completedToday != null ? completedToday : 0}</div>
                    <div class="card-footer">
                        <a href="/emoticare/admin/assessments?status=COMPLETED" class="card-link">See details →</a>
                    </div>
                </div>
            </div>

            <!-- Risk Level Distribution -->
            <div class="section">
                <h2>Risk Level Distribution</h2>
                <c:choose>
                    <c:when test="${riskStats != null && riskStats.size() > 0}">
                        <table>
                            <thead>
                                <tr>
                                    <th>Risk Level</th>
                                    <th>Count</th>
                                    <th>Percentage</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="total" value="0" />
                                <c:forEach var="entry" items="${riskStats}">
                                    <c:set var="total" value="${total + entry.value}" />
                                </c:forEach>

                                <c:forEach var="entry" items="${riskStats}">
                                    <tr>
                                        <td>
                                            <span class="status-badge 
                                                <c:choose>
                                                    <c:when test="${entry.key == 'HIGH'}">risk-high</c:when>
                                                    <c:when test="${entry.key == 'MEDIUM'}">risk-medium</c:when>
                                                    <c:otherwise>risk-low</c:otherwise>
                                                </c:choose>">
                                                ${entry.key}
                                            </span>
                                        </td>
                                        <td>${entry.value}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${total > 0}">
                                                    ${(entry.value * 100 / total).toStringAsFixed(1)}%
                                                </c:when>
                                                <c:otherwise>
                                                    0%
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:when>
                    <c:otherwise>
                        <div class="no-data">
                            <p>No assessment data available yet.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Quick Actions -->
            <div class="section">
                <h2>Quick Actions</h2>
                <div class="action-buttons">
                    <a href="/emoticare/admin/assessments" class="btn btn-primary">View All Assessments</a>
                    <a href="/emoticare/admin/users" class="btn btn-secondary">Manage Users</a>
                    <a href="/emoticare/logout" class="btn btn-secondary">Logout</a>
                </div>
            </div>

            <!-- System Info -->
            <div class="section">
                <h2>System Information</h2>
                <table>
                    <tbody>
                        <tr>
                            <td><strong>System Name</strong></td>
                            <td>Emoticare Assessment Platform</td>
                        </tr>
                        <tr>
                            <td><strong>Current Date & Time</strong></td>
                            <td><fmt:formatDate value="${systemDate}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                        </tr>
                        <tr>
                            <td><strong>Version</strong></td>
                            <td>1.0.0</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>