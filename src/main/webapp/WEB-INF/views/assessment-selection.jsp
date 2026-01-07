<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Choose Your Assessment - EmotiCare</title>
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
        
        .header {
            text-align: center;
            margin-bottom: 48px;
        }
        
        .header h1 {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 12px;
        }
        
        .header p {
            font-size: 16px;
            color: #9ca3af;
        }
        
        .breadcrumb {
            font-size: 14px;
            color: #6366f1;
            margin-bottom: 24px;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        
        .breadcrumb:hover {
            color: #8b5cf6;
        }
        
        .assessments-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 24px;
        }
        
        .assessment-card {
            background: #242838;
            border: 2px solid #2d3142;
            border-radius: 16px;
            padding: 32px;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
        }
        
        .assessment-card:hover {
            border-color: #6366f1;
            background: #2d3142;
            box-shadow: 0 12px 32px rgba(99, 102, 241, 0.2);
            transform: translateY(-4px);
        }
        
        .assessment-icon {
            font-size: 48px;
            margin-bottom: 16px;
        }
        
        .assessment-card h3 {
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 12px;
            color: #ffffff;
        }
        
        .assessment-card p {
            font-size: 14px;
            color: #d1d5db;
            margin-bottom: 8px;
            line-height: 1.6;
        }
        
        .assessment-details {
            background: #1a1d2e;
            border-radius: 12px;
            padding: 16px;
            margin: 16px 0;
            font-size: 13px;
            color: #9ca3af;
        }
        
        .assessment-details strong {
            color: #6366f1;
        }
        
        .assessment-form {
            margin-top: auto;
            padding-top: 20px;
            border-top: 1px solid #2d3142;
        }
        
        .assessment-form input[type="hidden"] {
            display: none;
        }
        
        .btn-start {
            width: 100%;
            padding: 14px 24px;
            background: #6366f1;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-start:hover {
            background: #4f46e5;
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(99, 102, 241, 0.3);
        }
        
        .btn-start:active {
            transform: translateY(0);
        }
        
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            background: #2d3142;
            color: #d1d5db;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            margin-bottom: 24px;
            transition: all 0.3s ease;
        }
        
        .back-button:hover {
            background: #3d4152;
            color: #ffffff;
        }
        
        .info-box {
            background: rgba(99, 102, 241, 0.1);
            border-left: 4px solid #6366f1;
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 32px;
            font-size: 14px;
            color: #d1d5db;
        }
        
        .info-box strong {
            color: #6366f1;
        }
        
        .spinner {
            display: none;
            width: 16px;
            height: 16px;
            border: 2px solid #ffffff;
            border-top: 2px solid #6366f1;
            border-radius: 50%;
            animation: spin 0.6s linear infinite;
        }
        
        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        
        .btn-start:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        
        .btn-start.loading {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-start.loading .spinner {
            display: block;
        }
        
        .btn-start.loading span {
            display: none;
        }
        
        @media (max-width: 768px) {
            .assessments-grid {
                grid-template-columns: 1fr;
            }
            
            .header h1 {
                font-size: 24px;
            }
        }
        
        .error-message {
            background: #ef4444;
            color: white;
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            display: none;
        }
        
        .error-message.show {
            display: block;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Back Button -->
        <a href="${pageContext.request.contextPath}/dashboard" class="back-button">
            ← Back to Dashboard
        </a>
        
        <!-- Header -->
        <div class="header">
            <h1>Choose Your Assessment 📋</h1>
            <p>Select a validated clinical tool to better understand your current mental state</p>
        </div>
        
        <!-- Info Box -->
        <div class="info-box">
            <strong>ℹ️ Note:</strong> All assessments are screening tools, not clinical diagnoses. 
            If you're in crisis, please contact emergency services or call <strong>1-800-273-8255</strong>.
        </div>
        
        <!-- Error Message -->
        <div class="error-message" id="errorMessage"></div>
        
        <!-- Assessments Grid -->
        <div class="assessments-grid">
            
            <!-- PHQ-9 Assessment -->
            <c:forEach var="type" items="${assessmentTypes}">
                <div class="assessment-card">
                    <div class="assessment-icon">
                        <c:choose>
                            <c:when test="${type.id == 1}">📋</c:when>
                            <c:when test="${type.id == 2}">😰</c:when>
                            <c:when test="${type.id == 3}">⚡</c:when>
                            <c:otherwise>❓</c:otherwise>
                        </c:choose>
                    </div>
                    
                    <h3>${type.name}</h3>
                    <p>${type.description}</p>
                    
                    <div class="assessment-details">
                        <div><strong>Duration:</strong> 5-10 minutes</div>
                        <div><strong>Questions:</strong> 
                            <c:choose>
                                <c:when test="${type.code == 'PHQ-9'}">9</c:when>
                                <c:when test="${type.code == 'GAD-7'}">7</c:when>
                                <c:when test="${type.code == 'PSS-10'}">10</c:when>
                                <c:otherwise>Varies</c:otherwise>
                            </c:choose>
                        </div>
                        <div><strong>Type:</strong> ${type.code}</div>
                    </div>
                    
                    <!-- Form untuk submit assessmentTypeId -->
                    <form action="${pageContext.request.contextPath}/assessment/start" 
                          method="POST" 
                          class="assessment-form"
                          onsubmit="handleSubmit(event, this)">
                        
                        <input type="hidden" name="assessmentTypeId" value="${type.id}">
                        
                        <button type="submit" class="btn-start" id="btn-${type.id}">
                            <span>Start Assessment →</span>
                            <div class="spinner"></div>
                        </button>
                    </form>
                </div>
            </c:forEach>
            
        </div>
        
    </div>
    
    <script>
        function handleSubmit(event, form) {
            event.preventDefault();
            
            // Disable all buttons
            document.querySelectorAll('.btn-start').forEach(btn => {
                btn.disabled = true;
            });
            
            // Get the button that was clicked
            const button = event.submitter || form.querySelector('.btn-start');
            
            // Add loading state
            button.classList.add('loading');
            
            // Submit form
            setTimeout(() => {
                form.submit();
            }, 300);
        }
        
        // Show error if any
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('error')) {
            const error = urlParams.get('error');
            const errorDiv = document.getElementById('errorMessage');
            errorDiv.textContent = 'Error: ' + error;
            errorDiv.classList.add('show');
        }
    </script>
</body>
</html>
