<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Users - EmotiCare</title>

    <!-- Sesuaikan styling dengan tema EmotiCare (dark-ish) -->
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
            background: #0f172a;
            color: #e5e7eb;
            min-height: 100vh;
            padding: 32px;
        }

        .page-container {
            max-width: 1100px;
            margin: 0 auto;
        }

        h1 {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .subtitle {
            font-size: 14px;
            color: #9ca3af;
            margin-bottom: 24px;
        }

        .card {
            background: #111827;
            border-radius: 16px;
            padding: 20px 24px;
            box-shadow: 0 20px 25px -5px rgba(0,0,0,0.5);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .card-title {
            font-size: 16px;
            font-weight: 600;
        }

        .badge-admin {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 999px;
            background: rgba(56,189,248,0.15);
            color: #38bdf8;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 8px;
            font-size: 14px;
        }

        thead {
            background: #1f2937;
        }

        th, td {
            padding: 10px 12px;
            border-bottom: 1px solid #1f2937;
        }

        th {
            text-align: left;
            font-weight: 600;
            color: #9ca3af;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        tr:nth-child(even) {
            background: #020617;
        }

        tr:hover {
            background: #1f2937;
        }

        .role-input {
            width: 60px;
            padding: 4px 6px;
            font-size: 12px;
            border-radius: 6px;
            border: 1px solid #374151;
            background: #020617;
            color: #e5e7eb;
        }

        .btn {
            border: none;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-role {
            background: #4b5563;
            color: #e5e7eb;
            margin-right: 4px;
        }

        .btn-role:hover {
            background: #6b7280;
        }

        .btn-activate {
            background: #22c55e;
            color: #022c22;
        }

        .btn-activate:hover {
            background: #16a34a;
        }

        .btn-deactivate {
            background: #b91c1c;
            color: #fee2e2;
        }

        .btn-deactivate:hover {
            background: #991b1b;
        }

        .status-pill {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 600;
        }

        .status-active {
            background: rgba(34,197,94,0.15);
            color: #4ade80;
        }

        .status-inactive {
            background: rgba(248,113,113,0.15);
            color: #f97373;
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .top-left {
            font-size: 14px;
        }

        .back-link {
            font-size: 13px;
            color: #a5b4fc;
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>
<div class="page-container">
    <div class="top-bar">
        <div class="top-left">
            Logged in as <strong>${username}</strong>
        </div>
        <div class="top-right">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">← Back to Admin Dashboard</a>
        </div>
    </div>

    <h1>Manage Users</h1>
    <p class="subtitle">View and manage all registered users. Change roles or activate/deactivate accounts.</p>

    <div class="card">
        <div class="card-header">
            <div class="card-title">
                User List
            </div>
            <div>
                <span class="badge-admin">Admin Panel</span>
            </div>
        </div>

        <table>
            <thead>
            <tr>
                <th style="width: 60px;">ID</th>
                <th>Username</th>
                <th>Email</th>
                <th style="width: 80px;">Role ID</th>
                <th style="width: 90px;">Status</th>
                <th style="width: 260px;">Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="u" items="${users}">
                <tr>
                    <td>${u.id}</td>
                    <td>${u.username}</td>
                    <td>${u.email}</td>
                    <td>${u.roleId}</td>
                    <td>
                        <c:choose>
                            <c:when test="${u.active}">
                                <span class="status-pill status-active">Active</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-pill status-inactive">Inactive</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <!-- Ubah Role -->
                        <form action="${pageContext.request.contextPath}/admin/users/change-role" method="post" style="display:inline;">
                            <input type="hidden" name="userId" value="${u.id}">
                            <input type="number" name="roleId" value="${u.roleId}" class="role-input" />
                            <button type="submit" class="btn btn-role">Change Role</button>
                        </form>

                        <!-- Aktif / Nonaktif -->
                        <form action="${pageContext.request.contextPath}/admin/users/set-active" method="post" style="display:inline;">
                            <input type="hidden" name="userId" value="${u.id}">
                            <input type="hidden" name="active" value="${!u.active}" />
                            <c:choose>
                                <c:when test="${u.active}">
                                    <button type="submit" class="btn btn-deactivate">Deactivate</button>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" class="btn btn-activate">Activate</button>
                                </c:otherwise>
                            </c:choose>
                        </form>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty users}">
                <tr>
                    <td colspan="6" style="text-align:center; color:#9ca3af; padding:16px;">
                        No users found.
                    </td>
                </tr>
            </c:if>

            </tbody>
        </table>
    </div>
</div>
</body>
</html>
