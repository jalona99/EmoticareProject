<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Schedule Session - ${profile.name} - EmotiCare</title>
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                rel="stylesheet">
            <style>
                :root {
                    --primary: #6366f1;
                    --primary-hover: #4f46e5;
                    --bg-dark: #1a1d2e;
                    --bg-card: #242838;
                    --bg-input: #2d3142;
                    --text-main: #ffffff;
                    --text-muted: #9ca3af;
                    --border: #2d3142;
                }

                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Inter', sans-serif;
                    background: var(--bg-dark);
                    color: var(--text-main);
                    min-height: 100vh;
                    padding: 40px 20px;
                }

                .container {
                    max-width: 1000px;
                    margin: 0 auto;
                }

                .header {
                    margin-bottom: 32px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .professional-mini-bio {
                    display: flex;
                    align-items: center;
                    gap: 16px;
                    background: var(--bg-card);
                    padding: 20px 24px;
                    border-radius: 16px;
                    border: 1px solid var(--border);
                    margin-bottom: 24px;
                }

                .avatar-small {
                    width: 50px;
                    height: 50px;
                    background: var(--primary);
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 20px;
                    font-weight: 700;
                    color: white;
                }

                .mini-info h2 {
                    font-size: 18px;
                    font-weight: 700;
                }

                .mini-info p {
                    font-size: 13px;
                    color: var(--text-muted);
                }

                .back-btn {
                    text-decoration: none;
                    color: var(--text-muted);
                    font-weight: 600;
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    transition: color 0.2s;
                }

                .back-btn:hover {
                    color: var(--text-main);
                }

                .calendly-container {
                    background: var(--bg-card);
                    border: 1px solid var(--border);
                    border-radius: 20px;
                    overflow: hidden;
                    min-height: 700px;
                }
            </style>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <div>
                        <h1 style="font-size: 24px;">Schedule Your Session</h1>
                    </div>
                    <a href="${pageContext.request.contextPath}/telehealth" class="back-btn">
                        ← Back to Professionals
                    </a>
                </header>

                <div class="professional-mini-bio">
                    <div class="avatar-small">
                        ${profile.name.substring(0, 1)}
                    </div>
                    <div class="mini-info">
                        <h2>${profile.name}, ${profile.credentials}</h2>
                        <p>Specialty: ${profile.specialty}</p>
                    </div>
                </div>

                <div class="calendly-container">
                    <!-- Calendly inline widget begin -->
                    <div class="calendly-inline-widget" data-url="${profile.calendlyUrl}"
                        style="min-width:320px;height:700px;"></div>
                    <script type="text/javascript" src="https://assets.calendly.com/assets/external/widget.js"
                        async></script>
                    <!-- Calendly inline widget end -->
                </div>
            </div>
        </body>

        </html>