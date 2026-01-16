<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Chat Risk Alerts - EmotiCare Admin</title>
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

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 16px;
        }

        .back-link {
            font-size: 13px;
            color: #a5b4fc;
            text-decoration: none;
        }

        .back-link:hover { text-decoration: underline; }

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
            margin-bottom: 24px;
        }

        .alert {
            padding: 10px 12px;
            border-radius: 10px;
            font-size: 13px;
            margin-bottom: 16px;
        }

        .alert-success { background: rgba(34,197,94,0.15); color: #4ade80; }
        .alert-error { background: rgba(248,113,113,0.15); color: #fca5a5; }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 8px;
            font-size: 14px;
        }

        thead { background: #1f2937; }

        th, td {
            padding: 10px 12px;
            border-bottom: 1px solid #1f2937;
            text-align: left;
            vertical-align: top;
        }

        th {
            font-weight: 600;
            color: #9ca3af;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        tr:nth-child(even) { background: #020617; }
        tr:hover { background: #1f2937; }

        .status {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-new { background: rgba(248,113,113,0.2); color: #fca5a5; }
        .status-ack { background: rgba(59,130,246,0.2); color: #93c5fd; }

        .btn {
            border: none;
            padding: 8px 14px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            background: #4f46e5;
            color: white;
            text-decoration: none;
            display: inline-block;
        }

        .btn-secondary { background: #334155; color: #e2e8f0; }
    </style>
</head>
<body>
<div class="page-container">
    <div class="top-bar">
        <div>Logged in as <strong>${username}</strong></div>
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-link">Back to Admin Dashboard</a>
    </div>

    <h1>Chat Risk Alerts</h1>
    <p class="subtitle">Alerts generated when chatbot messages indicate self-harm risk. No chat content is stored here.</p>

    <div class="card">
        <c:if test="${param.success == 'acknowledged'}">
            <div class="alert alert-success">Alert acknowledged.</div>
        </c:if>
        <c:if test="${param.error == 'ack_failed'}">
            <div class="alert alert-error">Failed to acknowledge alert.</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>

        <table>
            <thead>
                <tr>
                    <th>Alerted At</th>
                    <th>Student</th>
                    <th>Email</th>
                    <th>User ID</th>
                    <th>Session ID</th>
                    <th>Trigger</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="alert" items="${alerts}">
                    <tr>
                        <td>${alert.createdAt}</td>
                        <td>${alert.username}</td>
                        <td>${alert.email}</td>
                        <td>${alert.userId}</td>
                        <td>${alert.sessionId}</td>
                        <td>${alert.trigger}</td>
                        <td>
                            <span class="status ${alert.acknowledged ? 'status-ack' : 'status-new'}">
                                ${alert.acknowledged ? 'acknowledged' : 'new'}
                            </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${!alert.acknowledged}">
                                    <form action="${pageContext.request.contextPath}/admin/chat-alerts/acknowledge" method="post">
                                        <input type="hidden" name="id" value="${alert.id}" />
                                        <button type="submit" class="btn btn-secondary">Acknowledge</button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <span style="color:#9ca3af;">-</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty alerts}">
                    <tr>
                        <td colspan="8" style="text-align:center; color:#9ca3af; padding:16px;">No chat alerts yet.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
