<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Your Account - EmotiCare</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #6366f1;
            --primary-hover: #4f46e5;
            --bg-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --text-main: #1e293b;
            --text-muted: #64748b;
            --error: #ef4444;
            --success: #10b981;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: #f8fafc;
            background-image: radial-gradient(at 0% 0%, hsla(253,16%,7%,1) 0, transparent 50%), 
                              radial-gradient(at 100% 0%, hsla(225,39%,30%,1) 0, transparent 50%);
            background-color: #0f172a;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .register-card {
            background: white;
            border-radius: 24px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            width: 100%;
            max-width: 480px;
            padding: 40px;
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .header {
            text-align: center;
            margin-bottom: 32px;
        }

        .header .logo {
            font-size: 32px;
            margin-bottom: 8px;
            display: block;
        }

        .header h1 {
            color: var(--text-main);
            font-size: 24px;
            font-weight: 700;
            letter-spacing: -0.025em;
        }

        .header p {
            color: var(--text-muted);
            font-size: 14px;
            margin-top: 4px;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            color: var(--text-main);
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid #e2e8f0;
            border-radius: 12px;
            font-size: 15px;
            transition: all 0.2s ease;
            color: var(--text-main);
        }

        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
        }

        /* Password Requirements - Subtle Design */
        .password-requirements {
            font-size: 11px;
            color: var(--text-muted);
            margin-top: 6px;
            padding: 8px 12px;
            background: #f1f5f9;
            border-radius: 8px;
            display: none; /* Hidden by default, shown on focus */
        }

        input[type="password"]:focus + .password-requirements {
            display: block;
        }

        .grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }

        .btn-submit:hover {
            background: var(--primary-hover);
            transform: translateY(-1px);
            box-shadow: 0 10px 15px -3px rgba(99, 102, 241, 0.3);
        }

        .alert-error {
            background: #fef2f2;
            color: var(--error);
            padding: 12px;
            border-radius: 10px;
            border: 1px solid #fee2e2;
            font-size: 13px;
            margin-bottom: 20px;
            text-align: center;
        }

        .error-message {
            color: var(--error);
            font-size: 11px;
            font-weight: 500;
            margin-top: 4px;
        }

        .footer-link {
            text-align: center;
            margin-top: 24px;
            font-size: 14px;
            color: var(--text-muted);
        }

        .footer-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 600;
        }

        .footer-link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 480px) {
            .grid-2 { grid-template-columns: 1fr; }
            .register-card { padding: 30px 20px; }
        }
    </style>
</head>
<body>

    <div class="register-card">
        <div class="header">
            <span class="logo">🧠</span>
            <h1>Join EmotiCare</h1>
            <p>Start your mental wellness journey today.</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert-error">
                ${error}
            </div>
        </c:if>

        <form:form modelAttribute="user" method="POST" action="/emoticare/register">
            
            <div class="form-group">
                <form:label path="username">Username</form:label>
                <form:input path="username" placeholder="e.g. alex_doe" required="true" />
                <form:errors path="username" cssClass="error-message" />
            </div>

            <div class="form-group">
                <form:label path="email">Institutional Email</form:label>
                <form:input path="email" type="email" placeholder="name@university.edu" required="true" />
                <form:errors path="email" cssClass="error-message" />
            </div>

            <div class="grid-2">
                <div class="form-group">
                    <form:label path="password">Password</form:label>
                    <form:input path="password" type="password" placeholder="••••••••" required="true" />
                    <div class="password-requirements">
                        8+ chars, A-Z, a-z, 0-9, & symbols (@$!%*?&)
                    </div>
                    <form:errors path="password" cssClass="error-message" />
                </div>
                <div class="form-group">
                    <form:label path="confirmPassword">Confirm</form:label>
                    <form:input path="confirmPassword" type="password" placeholder="••••••••" required="true" />
                </div>
            </div>

            <div class="form-group">
                    <%-- Dropdown dihapus dan diganti dengan hidden input --%>
                    <form:hidden path="roleId" value="1" /> 

            <p class="role-note" style="text-align: center; font-size: 12px; color: #64748b; margin-top: 15px;">
                     By creating an account, you are registering as a <strong>Student</strong>.
            </p>
            </div>

            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

            <button type="submit" class="btn-submit">Create Account</button>

            <div class="footer-link">
                Already have an account? <a href="/emoticare/login">Sign In</a>
            </div>
        </form:form>
    </div>

</body>
</html>
