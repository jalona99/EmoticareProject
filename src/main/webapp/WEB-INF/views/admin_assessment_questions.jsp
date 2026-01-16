<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Questions - ${assessmentType.name}</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #1a1d2e; color: #ffffff; padding: 24px; }
        .container { max-width: 1200px; margin: 0 auto; }
        .header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 32px; }
        h1 { font-size: 28px; font-weight: 700; margin-bottom: 8px; }
        .subtitle { color: #9ca3af; }
        .btn { padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; text-decoration: none; display: inline-block; transition: all 0.2s; }
        .btn-primary { background: #6366f1; color: white; }
        .btn-secondary { background: #2d3142; color: white; }
        .btn-danger { background: #ef4444; color: white; }
        .table-container { background: #242838; border-radius: 12px; border: 1px solid #2d3142; overflow: hidden; margin-top: 24px; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #1a1d2e; padding: 16px; text-align: left; color: #9ca3af; font-size: 13px; text-transform: uppercase; border-bottom: 1px solid #2d3142; }
        td { padding: 16px; border-bottom: 1px solid #2d3142; font-size: 14px; }
        tr:hover { background: #2d3142; }
        .badge { padding: 4px 8px; border-radius: 4px; font-size: 11px; font-weight: 700; }
        .badge-reverse { background: #f59e0b; color: white; }
        .actions { display: flex; gap: 8px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div>
                <a href="${pageContext.request.contextPath}/admin/assessments" style="color: #6366f1; text-decoration: none; font-size: 14px;">← Back to Assessments</a>
                <h1 style="margin-top: 12px;">Manage Questions</h1>
                <p class="subtitle">${assessmentType.name} (${assessmentType.code})</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/assessments/questions/add?typeId=${assessmentType.id}" class="btn btn-primary">+ Add New Question</a>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th width="80">Order</th>
                        <th width="120">Code</th>
                        <th>Question Text</th>
                        <th width="120">Scoring</th>
                        <th width="150">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="q" items="${questions}">
                        <tr>
                            <td><strong>${q.questionOrder}</strong></td>
                            <td><code>${q.questionCode}</code></td>
                            <td>${q.questionText}</td>
                            <td>
                                <c:if test="${q.reverseScored}">
                                    <span class="badge badge-reverse">Reverse</span>
                                </c:if>
                                <c:if test="${!q.reverseScored}">
                                    <span style="color: #9ca3af;">Standard</span>
                                </c:if>
                            </td>
                            <td>
                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/admin/assessments/questions/edit/${q.id}" class="btn btn-secondary" style="padding: 6px 12px; font-size: 12px;">Edit</a>
                                    <form action="${pageContext.request.contextPath}/admin/assessments/questions/delete/${q.id}" method="post" onsubmit="return confirm('Are you sure you want to delete this question?');">
                                        <input type="hidden" name="typeId" value="${assessmentType.id}">
                                        <button type="submit" class="btn btn-danger" style="padding: 6px 12px; font-size: 12px;">Delete</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty questions}">
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 48px; color: #9ca3af;">No questions found for this assessment.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
