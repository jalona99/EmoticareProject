<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assessment Results - EmotiCare</title>
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
            padding: 40px 20px;
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
        }
        
        /* Results Card */
        .results-card {
            background: #242838;
            border-radius: 20px;
            padding: 48px;
            border: 1px solid #2d3142;
            margin-bottom: 24px;
        }
        
        .results-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .results-header h1 {
            font-size: 32px;
            margin-bottom: 8px;
        }
        
        .results-header p {
            color: #9ca3af;
            font-size: 16px;
        }
        
        /* Score Display */
        .score-display {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .score-circle {
            width: 200px;
            height: 200px;
            margin: 0 auto 24px;
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            border-radius: 50%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            box-shadow: 0 20px 40px rgba(99, 102, 241, 0.3);
        }
        
        .score-number {
            font-size: 64px;
            font-weight: 700;
            line-height: 1;
        }
        
        .score-label {
            color: rgba(255, 255, 255, 0.8);
            font-size: 14px;
            margin-top: 8px;
        }
        
        /* Risk Badge */
        .risk-badge {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 14px;
        }
        
        .risk-minimal { background: #10b981; color: white; }
        .risk-mild { background: #3b82f6; color: white; }
        .risk-moderate { background: #f59e0b; color: white; }
        .risk-moderately_severe { background: #f97316; color: white; }
        .risk-severe { background: #ef4444; color: white; }
        
        /* Interpretation Section */
        .section {
            margin-bottom: 32px;
        }
        
        .section-title {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .interpretation-text {
            background: #1a1d2e;
            padding: 20px;
            border-radius: 12px;
            color: #d1d5db;
            font-size: 16px;
            line-height: 1.6;
        }
        
        /* Recommendations */
        .recommendations-list {
            background: #1a1d2e;
            padding: 20px;
            border-radius: 12px;
        }
        
        .recommendations-list ul {
            list-style: none;
            padding: 0;
        }
        
        .recommendations-list li {
            padding: 12px 0;
            border-bottom: 1px solid #2d3142;
            color: #d1d5db;
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }
        
        .recommendations-list li:last-child {
            border-bottom: none;
        }
        
        .rec-icon {
            color: #6366f1;
            font-size: 20px;
        }
        
        /* Action Buttons */
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-top: 32px;
        }
        
        .btn {
            padding: 14px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-primary {
            background: #6366f1;
            color: #ffffff;
        }
        
        .btn-secondary {
            background: #2d3142;
            color: #ffffff;
        }
        
        .btn:hover {
            transform: translateY(-2px);
        }
        
        /* Info Box */
        .info-box {
            background: #1e40af;
            border-left: 4px solid #3b82f6;
            padding: 20px;
            border-radius: 8px;
            color: #dbeafe;
            margin-top: 32px;
        }
        
        .info-box strong {
            color: #ffffff;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="results-card">
            <!-- Header -->
            <div class="results-header">
                <h1>📊 Your Assessment Results</h1>
                <p>${assessmentType.name}</p>
            </div>
            
            <!-- Score Display -->
            <div class="score-display">
                <div class="score-circle">
                    <div class="score-number">${assessment.totalScore}</div>
                    <div class="score-label">Total Score</div>
                </div>
                
                <div class="risk-badge risk-${fn:toLowerCase(assessment.riskLevel)}">
                    ${assessment.riskLevel}
                </div>
            </div>
            
            <!-- Interpretation -->
            <div class="section">
                <div class="section-title">
                    <span>💡</span>
                    <span>What This Means</span>
                </div>
                <div class="interpretation-text">
                    ${interpretation}
                </div>
            </div>
            
            <!-- Recommendations -->
            <div class="section">
                <div class="section-title">
                    <span>📋</span>
                    <span>Recommended Next Steps</span>
                </div>
                <div class="recommendations-list">
                    <ul>
                        <c:forEach var="rec" items="${recommendations}">
                            <li>
                                <span class="rec-icon">•</span>
                                <span>${rec}</span>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </div>
            
            <!-- Info Box -->
            <div class="info-box">
                <strong>📌 Important Note:</strong> This assessment provides screening information only and should not be considered a clinical diagnosis. For accurate evaluation and treatment, please consult with a qualified mental health professional.
            </div>
            
            <!-- Action Buttons -->
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/assessment/select" class="btn btn-secondary">
                    Take Another Assessment
                </a>
                <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-primary">
                    Back to Dashboard
                </a>
            </div>
        </div>
    </div>
</body>
</html>
