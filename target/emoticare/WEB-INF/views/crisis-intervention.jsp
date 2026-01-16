<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crisis Support - EmotiCare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Inter', sans-serif;
            background: #7f1d1d;
            color: #ffffff;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
        }
        
        .crisis-container {
            max-width: 700px;
            background: #991b1b;
            border-radius: 20px;
            padding: 48px;
            border: 2px solid #dc2626;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5);
        }
        
        .crisis-icon {
            width: 100px;
            height: 100px;
            background: #dc2626;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 56px;
            margin: 0 auto 32px;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        h1 {
            font-size: 32px;
            font-weight: 700;
            text-align: center;
            margin-bottom: 24px;
        }
        
        .alert-text {
            font-size: 18px;
            line-height: 1.8;
            margin-bottom: 32px;
            text-align: center;
            color: #fecaca;
        }
        
        .alert-text strong {
            color: #ffffff;
        }
        
        /* Crisis Resources */
        .resources {
            background: #7f1d1d;
            border-left: 4px solid #fecaca;
            padding: 24px;
            border-radius: 12px;
            margin-bottom: 32px;
        }
        
        .resources h3 {
            font-size: 20px;
            margin-bottom: 20px;
            color: #fecaca;
        }
        
        .resource-item {
            background: #991b1b;
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 16px;
        }
        
        .resource-item strong {
            display: block;
            font-size: 16px;
            margin-bottom: 8px;
        }
        
        .resource-item a {
            color: #fecaca;
            text-decoration: none;
            font-size: 24px;
            font-weight: 700;
        }
        
        .resource-item a:hover {
            color: #ffffff;
        }
        
        .resource-item p {
            color: #fecaca;
            font-size: 14px;
            margin-top: 4px;
        }
        
        /* Action Buttons */
        .action-buttons {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        
        .btn {
            padding: 16px 32px;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            font-size: 18px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            text-decoration: none;
            display: block;
        }
        
        .btn-emergency {
            background: #ffffff;
            color: #dc2626;
        }
        
        .btn-emergency:hover {
            background: #fecaca;
            transform: scale(1.02);
        }
        
        .btn-secondary {
            background: #7f1d1d;
            color: #ffffff;
            border: 2px solid #dc2626;
        }
        
        .btn-secondary:hover {
            background: #991b1b;
        }
        
        /* Important Note */
        .important-note {
            background: #7f1d1d;
            padding: 20px;
            border-radius: 8px;
            margin-top: 32px;
            text-align: center;
            font-size: 14px;
            color: #fecaca;
        }
    </style>
</head>
<body>
    <div class="crisis-container">
        <div class="crisis-icon">🆘</div>
        
        <h1>We're Concerned About Your Well-Being</h1>
        
        <div class="alert-text">
            Your assessment responses indicate <strong>you may be experiencing thoughts of self-harm or severe distress</strong>. 
            Please know that <strong>help is available</strong> and you don't have to face this alone.
        </div>
        
        <!-- Crisis Resources -->
        <div class="resources">
            <h3>📞 Immediate Help Available 24/7</h3>
            
            <div class="resource-item">
                <strong>National Suicide Prevention Lifeline</strong>
                <a href="tel:988">988</a>
                <p>Call or text - Free, confidential support 24/7</p>
            </div>
            
            <div class="resource-item">
                <strong>Crisis Text Line</strong>
                <a href="sms:741741">Text "HELLO" to 741741</a>
                <p>Text with a trained crisis counselor</p>
            </div>
            
            <div class="resource-item">
                <strong>International Association for Suicide Prevention</strong>
                <a href="https://www.iasp.info/resources/Crisis_Centres/" target="_blank">Find Local Resources</a>
                <p>Global directory of crisis centers</p>
            </div>
            
            <div class="resource-item">
                <strong>Emergency Services</strong>
                <a href="tel:911">911</a>
                <p>For immediate life-threatening situations</p>
            </div>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons">
            <a href="tel:988" class="btn btn-emergency">
                📞 Call Crisis Hotline Now (988)
            </a>
            
            <a href="${pageContext.request.contextPath}/student/dashboard" class="btn btn-secondary">
                Return to Dashboard
            </a>
        </div>
        
        <!-- Important Note -->
        <div class="important-note">
            <strong>Your privacy is important.</strong> Crisis hotline calls are confidential. 
            EmotiCare has not shared your information with anyone. We're here to support you.
        </div>
    </div>
</body>
</html>
