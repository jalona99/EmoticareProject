<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Telehealth Professionals - EmotiCare</title>
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
                    margin-bottom: 48px;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .header h1 {
                    font-size: 32px;
                    font-weight: 700;
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

                .professional-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
                    gap: 24px;
                }

                .professional-card {
                    background: var(--bg-card);
                    border: 1px solid var(--border);
                    border-radius: 20px;
                    padding: 32px;
                    display: flex;
                    flex-direction: column;
                    gap: 16px;
                    transition: transform 0.3s ease, border-color 0.3s ease;
                }

                .professional-card:hover {
                    transform: translateY(-4px);
                    border-color: var(--primary);
                    box-shadow: 0 12px 24px rgba(99, 102, 241, 0.1);
                }

                .profile-header {
                    display: flex;
                    align-items: center;
                    gap: 20px;
                }

                .avatar {
                    width: 80px;
                    height: 80px;
                    background: var(--primary);
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 32px;
                    font-weight: 700;
                    color: white;
                }

                .professional-info h2 {
                    font-size: 22px;
                    font-weight: 700;
                    margin-bottom: 4px;
                }

                .credentials {
                    font-size: 14px;
                    color: var(--primary);
                    font-weight: 600;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                }

                .specialty {
                    background: rgba(99, 102, 241, 0.1);
                    color: var(--primary);
                    padding: 6px 12px;
                    border-radius: 8px;
                    font-size: 13px;
                    font-weight: 600;
                    align-self: flex-start;
                }

                .bio {
                    font-size: 15px;
                    line-height: 1.6;
                    color: var(--text-muted);
                    margin-top: 8px;
                }

                .schedule-btn {
                    margin-top: auto;
                    background: var(--primary);
                    color: white;
                    text-decoration: none;
                    padding: 14px;
                    border-radius: 12px;
                    text-align: center;
                    font-weight: 600;
                    transition: background 0.2s;
                }

                .schedule-btn:hover {
                    background: var(--primary-hover);
                }

                @media (max-width: 600px) {
                    .professional-grid {
                        grid-template-columns: 1fr;
                    }
                }
            </style>
        </head>

        <body>
            <div class="container">
                <header class="header">
                    <div>
                        <h1>Our Professionals</h1>
                        <p style="color: var(--text-muted); margin-top: 8px;">Schedule a session with one of our
                            certified mental health experts.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/student/dashboard" class="back-btn">
                        ← Back to Dashboard
                    </a>
                </header>

                <div class="professional-grid">
                    <c:forEach var="professional" items="${professionals}">
                        <div class="professional-card">
                            <div class="profile-header">
                                <div class="avatar">
                                    ${professional.name.substring(0, 1)}
                                </div>
                                <div class="professional-info">
                                    <h2>${professional.name}</h2>
                                    <div class="credentials">${professional.credentials}</div>
                                </div>
                            </div>
                            <div class="specialty">${professional.specialty}</div>
                            <p class="bio">${professional.bio}</p>
                            <a href="${pageContext.request.contextPath}/telehealth/schedule/${professional.id}"
                                class="schedule-btn">
                                Schedule Meeting
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </body>

        </html>