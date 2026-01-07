<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Disclaimer - EmotiCare</title>
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
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }
        
        .disclaimer-container {
            max-width: 700px;
            background: #242838;
            border-radius: 20px;
            padding: 48px;
            border: 1px solid #2d3142;
        }
        
        .icon-warning {
            width: 80px;
            height: 80px;
            background: #fbbf24;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            margin: 0 auto 32px;
        }
        
        h1 {
            font-size: 28px;
            font-weight: 700;
            text-align: center;
            margin-bottom: 24px;
        }
        
        .disclaimer-text {
            color: #d1d5db;
            font-size: 15px;
            line-height: 1.8;
            margin-bottom: 32px;
        }
        
        .disclaimer-text strong {
            color: #fbbf24;
        }
        
        .important-box {
            background: #1a1d2e;
            border-left: 4px solid #ef4444;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 32px;
        }
        
        .important-box h3 {
            color: #ef4444;
            font-size: 16px;
            margin-bottom: 12px;
        }
        
        .important-box ul {
            margin-left: 20px;
            color: #d1d5db;
        }
        
        .important-box li {
            margin-bottom: 8px;
        }
        
        .btn-group {
            display: flex;
            gap: 16px;
        }
        
        .btn {
            flex: 1;
            padding: 14px 24px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .btn-cancel {
            background: #2d3142;
            color: #ffffff;
        }
        
        .btn-cancel:hover {
            background: #3d4152;
        }
        
        .btn-accept {
            background: #6366f1;
            color: #ffffff;
        }
        
        .btn-accept:hover {
            background: #4f46e5;
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(99, 102, 241, 0.3);
        }
    </style>
</head>
<body>
    <div class="disclaimer-container">
        <div class="icon-warning">⚠️</div>
        
        <h1>Important Disclaimer</h1>
        
        <div class="disclaimer-text">
            <p>You are about to take the <strong>${assessmentType.name}</strong>.</p>
            <p style="margin-top: 16px;">
                This assessment tool is designed to provide <strong>initial insights</strong> into your mental well-being. 
                However, <strong>it is NOT a substitute for professional medical diagnosis</strong>.
            </p>
        </div>
        
        <div class="important-box">
            <h3>🚨 IMPORTANT</h3>
            <ul>
                <li>If you experience thoughts of self-harm or suicide, <strong>call emergency services immediately</strong> or contact crisis hotline: <strong>1-800-273-8255</strong></li>
                <li>Results should be discussed with a qualified mental health professional</li>
                <li>This tool provides screening information only, not a clinical diagnosis</li>
                <li>Your responses are confidential and encrypted with HIPAA-compliant security</li>
            </ul>
        </div>
        
        <form action="${pageContext.request.contextPath}/assessment/confirm-disclaimer" method="POST">
            <div class="btn-group">
                <button type="button" class="btn btn-cancel" onclick="history.back()">
                    Cancel
                </button>
                <button type="submit" class="btn btn-accept">
                    I Understand & Agree to Continue
                </button>
            </div>
        </form>
    </div>
</body>
</html>
