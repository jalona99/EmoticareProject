<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assessment Detail - EmotiCare Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Inter', sans-serif;
            background: #1a1d2e;
            color: #ffffff;
            min-height: 100vh;
            padding: 24px;
        }
        
        .container { max-width: 1000px; margin: 0 auto; }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
        }
        
        h1 { font-size: 28px; font-weight: 700; }
        h2 { font-size: 20px; font-weight: 700; margin-bottom: 16px; }
        
        .detail-card {
            background: #242838;
            padding: 24px;
            border-radius: 12px;
            border: 1px solid #2d3142;
            margin-bottom: 24px;
        }
        
        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }
        
        .detail-item {
            padding-bottom: 16px;
            border-bottom: 1px solid #2d3142;
        }
        
        .detail-item:last-child {
            border-bottom: none;
        }
        
        .detail-label { 
            color: #9ca3af; 
            font-size: 11px; 
            text-transform: uppercase; 
            letter-spacing: 0.05em;
        }
        .detail-value { 
            font-size: 16px; 
            margin-top: 8px; 
            font-weight: 500;
        }
        
        .responses-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 16px;
        }
        
        .responses-table th {
            background: #1a1d2e;
            padding: 12px 16px;
            text-align: left;
            font-weight: 600;
            font-size: 12px;
            text-transform: uppercase;
            border-bottom: 2px solid #2d3142;
        }
        
        .responses-table td {
            padding: 12px 16px;
            border-bottom: 1px solid #2d3142;
            font-size: 14px;
        }
        
        .responses-table tr:hover {
            background: #2d3142;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-secondary { background: #2d3142; color: #ffffff; }
        .btn-secondary:hover { background: #3d4152; }
        
        .btn-primary { background: #6366f1; color: #ffffff; }
        .btn-primary:hover { background: #4f46e5; }
        
        .risk-CRITICAL { color: #ef4444; font-weight: 700; }
        .risk-HIGH { color: #ef4444; font-weight: 700; }
        .risk-MODERATE { color: #f59e0b; font-weight: 600; }
        .risk-LOW { color: #10b981; font-weight: 600; }
        .risk-UNKNOWN { color: #6b7280; }
        
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .status-COMPLETED { background: #10b981; color: #fff; }
        .status-IN_PROGRESS { background: #f59e0b; color: #fff; }
        .status-DRAFT { background: #6b7280; color: #fff; }
        
        .info-section {
            margin-bottom: 32px;
        }
        
        .action-bar {
            display: flex;
            gap: 12px;
            justify-content: center;
            margin-top: 32px;
        }
        
        .empty-state {
            padding: 32px;
            text-align: center;
            color: #9ca3af;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Assessment #${assessment.id}</h1>
            <a href="${pageContext.request.contextPath}/admin/assessments" class="btn btn-secondary">← Back</a>
        </div>
        
        <!-- Assessment Info Section -->
        <div class="detail-card info-section">
            <h2>📋 Assessment Information</h2>
            
            <div class="detail-grid">
                <div class="detail-item">
                    <div class="detail-label">Assessment ID</div>
                    <div class="detail-value">#${assessment.id}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Status</div>
                    <div class="detail-value">
                        <span class="status-badge status-${assessment.status}">${assessment.status}</span>
                    </div>
                </div>
            </div>
            
            <div class="detail-grid">
                <div class="detail-item">
                    <div class="detail-label">Student ID</div>
                    <div class="detail-value">${assessment.userId}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Username</div>
                    <div class="detail-value">${assessment.username}</div>
                </div>
            </div>
            
            <div class="detail-grid">
                <div class="detail-item">
                    <div class="detail-label">Email</div>
                    <div class="detail-value">${assessment.email}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Assessment Type</div>
                    <div class="detail-value">${assessment.typeName} <small style="color: #9ca3af;">(${assessment.typeCode})</small></div>
                </div>
            </div>
            
            <div class="detail-grid">
                <div class="detail-item">
                    <div class="detail-label">Total Score</div>
                    <div class="detail-value">${assessment.totalScore > 0 ? assessment.totalScore : '—'}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Risk Level</div>
                    <div class="detail-value">
                        <c:choose>
                            <c:when test="${assessment.riskLevel != null}">
                                <span class="risk-${assessment.riskLevel}">${assessment.riskLevel}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="risk-UNKNOWN">Not Assigned</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <div class="detail-grid">
                <div class="detail-item">
                    <div class="detail-label">Started At</div>
                    <div class="detail-value">${assessment.startedAt}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Completed At</div>
                    <div class="detail-value">${assessment.completedAt != null ? assessment.completedAt : '—'}</div>
                </div>
            </div>
        </div>
        
        <!-- Responses Section -->
        <div class="detail-card info-section">
            <h2>📝 Student Responses (${responseCount} answers)</h2>
            
            <c:choose>
                <c:when test="${not empty responses}">
                    <table class="responses-table">
                        <thead>
                            <tr>
                                <th>Question #</th>
                                <th>Scale Value</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="resp" items="${responses}">
                                <tr>
                                    <td><strong>#${resp.questionId}</strong></td>
                                    <td>${resp.scaleValue}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <p>No responses recorded yet.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-bar">
            <a href="${pageContext.request.contextPath}/admin/assessments" class="btn btn-secondary">
                ← Back to List
            </a>
        </div>
    </div>
</body>
</html>
