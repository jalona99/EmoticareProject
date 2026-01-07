<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Successful - EmotiCare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #6366f1;
            --success: #10b981;
            --text-main: #1e293b;
            --text-muted: #64748b;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            /* Konsistensi Background dengan halaman registrasi */
            background-image: radial-gradient(at 0% 0%, hsla(253,16%,7%,1) 0, transparent 50%), 
                              radial-gradient(at 100% 0%, hsla(225,39%,30%,1) 0, transparent 50%);
            background-color: #0f172a;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .success-card {
            background: white;
            border-radius: 24px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            text-align: center;
            padding: 50px 40px;
            max-width: 450px;
            width: 100%;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .icon-circle {
            width: 80px;
            height: 80px;
            background: #ecfdf5;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 0 auto 24px;
            border: 2px solid #d1fae5;
        }

        .icon-check {
            font-size: 40px;
            color: var(--success);
        }

        h1 {
            color: var(--text-main);
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 12px;
            letter-spacing: -0.025em;
        }

        .message-content {
            color: var(--text-muted);
            font-size: 15px;
            line-height: 1.6;
            margin-bottom: 32px;
        }

        .redirect-text {
            font-size: 13px;
            color: #94a3b8;
            margin-top: 20px;
            display: block;
        }

        .btn-login {
            display: block;
            padding: 14px 24px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s ease;
            box-shadow: 0 10px 15px -3px rgba(99, 102, 241, 0.3);
        }

        .btn-login:hover {
            background: #4f46e5;
            transform: translateY(-2px);
            box-shadow: 0 15px 20px -5px rgba(99, 102, 241, 0.4);
        }

        /* Progress Bar for Auto-Redirect */
        .progress-bar {
            height: 4px;
            width: 100%;
            background: #f1f5f9;
            border-radius: 2px;
            margin-top: 32px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: var(--success);
            width: 0%;
            animation: loading 3s linear forwards;
        }

        @keyframes loading {
            from { width: 0%; }
            to { width: 100%; }
        }
    </style>
</head>
<body>

    <div class="success-card">
        <div class="icon-circle">
            <div class="icon-check">✓</div>
        </div>
        
        <h1>Account Created!</h1>
        
        <div class="message-content">
            <p>${successMessage}</p>
            <span class="redirect-text">Redirecting you to login page in 3 seconds...</span>
        </div>
        
        <a href="/emoticare/login" class="btn-login">Go to Login</a>

        <div class="progress-bar">
            <div class="progress-fill"></div>
        </div>
    </div>

    <script>
        // Redirect after 3 seconds
        setTimeout(() => {
            window.location.href = '/emoticare/login';
        }, 3000);
    </script>
</body>
</html>