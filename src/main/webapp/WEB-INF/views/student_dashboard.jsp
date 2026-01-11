<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Student Dashboard - EmotiCare</title>
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
                    max-width: 1200px;
                    margin: 0 auto;
                }

                .header {
                    margin-bottom: 48px;
                    text-align: center;
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

                .features-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                    gap: 24px;
                    margin-bottom: 40px;
                }

                .feature-card {
                    background: #242838;
                    border: 1px solid #2d3142;
                    border-radius: 16px;
                    padding: 32px;
                    text-decoration: none;
                    color: inherit;
                    transition: all 0.3s ease;
                    display: flex;
                    flex-direction: column;
                    min-height: 240px;
                }

                .feature-card:hover {
                    border-color: #6366f1;
                    background: #2d3142;
                    transform: translateY(-4px);
                    box-shadow: 0 12px 24px rgba(99, 102, 241, 0.2);
                }

                .feature-icon {
                    font-size: 48px;
                    margin-bottom: 16px;
                }

                .feature-card h3 {
                    font-size: 20px;
                    font-weight: 700;
                    margin-bottom: 12px;
                }

                .feature-card p {
                    font-size: 14px;
                    color: #d1d5db;
                    margin-bottom: 20px;
                    flex-grow: 1;
                }

                .feature-card-footer {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    padding-top: 16px;
                    border-top: 1px solid #2d3142;
                }

                .feature-status {
                    font-size: 12px;
                    color: #10b981;
                    font-weight: 600;
                }

                .arrow {
                    font-size: 20px;
                    color: #6366f1;
                }

                .quick-stats {
                    background: #242838;
                    border: 1px solid #2d3142;
                    border-radius: 16px;
                    padding: 24px;
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                    gap: 16px;
                    margin-top: 40px;
                }

                .stat-item {
                    text-align: center;
                }

                .stat-number {
                    font-size: 24px;
                    font-weight: 700;
                    color: #6366f1;
                    margin-bottom: 8px;
                }

                .stat-label {
                    font-size: 12px;
                    color: #9ca3af;
                    text-transform: uppercase;
                }

                .sidebar {
                    position: fixed;
                    left: 0;
                    top: 0;
                    width: 240px;
                    height: 100vh;
                    background: #242838;
                    border-right: 1px solid #2d3142;
                    padding: 24px;
                    overflow-y: auto;
                    display: none;
                }

                .sidebar.active {
                    display: block;
                }

                .sidebar-header {
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    margin-bottom: 32px;
                    font-weight: 700;
                    font-size: 18px;
                }

                .sidebar-menu a {
                    display: block;
                    padding: 12px 16px;
                    color: #d1d5db;
                    text-decoration: none;
                    border-radius: 8px;
                    margin-bottom: 8px;
                    transition: all 0.3s ease;
                }

                .sidebar-menu a:hover {
                    background: #1a1d2e;
                    color: #6366f1;
                }

                .sidebar-menu a.active {
                    background: #6366f1;
                    color: white;
                }

                .logout-btn {
                    position: fixed;
                    bottom: 20px;
                    left: 20px;
                    width: calc(240px - 40px);
                    padding: 12px;
                    background: #ef4444;
                    border: none;
                    border-radius: 8px;
                    color: white;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.3s ease;
                    text-align: center;
                }

                .logout-btn:hover {
                    background: #dc2626;
                }

                @media (max-width: 768px) {
                    .container {
                        padding-left: 0;
                    }

                    .features-grid {
                        grid-template-columns: 1fr;
                    }
                }
            </style>
        </head>

        <body>
            <!-- Navigation Sidebar -->
            <aside class="sidebar" id="sidebar">
                <div class="sidebar-header">
                    🧠 EmotiCare
                </div>
                <nav class="sidebar-menu">
                    <a href="${pageContext.request.contextPath}/student/dashboard" class="active">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/assessment/select">Self-Assessment</a>
                    <a href="${pageContext.request.contextPath}/learning" class="active">Learning Hub</a>
                    <a href="${pageContext.request.contextPath}/ai/support">AI Support</a>
                    <a href="${pageContext.request.contextPath}/telehealth">Telehealth</a>
                    <a href="${pageContext.request.contextPath}/forum">Peer Forum</a>
                </nav>
                <button class="logout-btn" onclick="logout()">Sign Out</button>
            </aside>

            <!-- Main Content -->
            <div class="container">
                <div class="header">
                    <h1>Welcome Back, ${userName}! 👋</h1>
                    <p>Choose a feature below to get started</p>
                </div>

                <!-- Feature Cards Grid -->
                <div class="features-grid">

                    <!-- 1. Self-Assessment Card -->
                    <a href="${pageContext.request.contextPath}/assessment/select" class="feature-card">
                        <div class="feature-icon">📋</div>
                        <h3>Self-Assessment</h3>
                        <p>Take validated mental health assessments including PHQ-9, GAD-7, and stress screening tests.
                        </p>
                        <div class="feature-card-footer">
                            <span class="feature-status">Get Started</span>
                            <span class="arrow">→</span>
                        </div>
                    </a>

                    <!-- 2. Learning Hub Card -->
                    <a href="${pageContext.request.contextPath}/learning" class="feature-card">
                        <div class="feature-icon">📚</div>
                        <h3>Learning Hub</h3>
                        <p>Access educational content on mental health, coping strategies, and wellness tips.</p>
                        <div class="feature-card-footer">
                            <span class="feature-status">Explore</span>
                            <span class="arrow">→</span>
                        </div>
                    </a>

                    <!-- 3. AI Support Card -->
                    <a href="${pageContext.request.contextPath}/ai/support" class="feature-card">
                        <div class="feature-icon">🤖</div>
                        <h3>AI Support</h3>
                        <p>Chat with our AI assistant for immediate support and personalized recommendations.</p>
                        <div class="feature-card-footer">
                            <span class="feature-status">Chat Now</span>
                            <span class="arrow">→</span>
                        </div>
                    </a>

                    <!-- 4. Telehealth Card -->
                    <a href="${pageContext.request.contextPath}/telehealth" class="feature-card">
                        <div class="feature-icon">🎥</div>
                        <h3>Telehealth</h3>
                        <p>Schedule video consultations with licensed mental health professionals.</p>
                        <div class="feature-card-footer">
                            <span class="feature-status">Book Now</span>
                            <span class="arrow">→</span>
                        </div>
                    </a>

                    <!-- 5. Peer Forum Card -->
                    <a href="${pageContext.request.contextPath}/forum" class="feature-card">
                        <div class="feature-icon">👥</div>
                        <h3>Peer Forum</h3>
                        <p>Connect with other students, share experiences, and find community support.</p>
                        <div class="feature-card-footer">
                            <span class="feature-status">Join</span>
                            <span class="arrow">→</span>
                        </div>
                    </a>

                    <!-- 6. Resources Card -->
                    <a href="${pageContext.request.contextPath}/resources" class="feature-card">
                        <div class="feature-icon">🎯</div>
                        <h3>Resources</h3>
                        <p>Find crisis hotlines, mental health contacts, and emergency resources.</p>
                        <div class="feature-card-footer">
                            <span class="feature-status">Browse</span>
                            <span class="arrow">→</span>
                        </div>
                    </a>

                </div>

                <!-- Badges / Achievements -->
                <div class="quick-stats" style="margin-top: 40px; margin-bottom: 20px;">
                    <h2 style="grid-column: 1 / -1; margin-bottom: 20px; font-size: 20px;">Your Achievements 🏆</h2>
                    <c:forEach var="badge" items="${badges}">
                        <div class="stat-item" style="background: #2d3142; padding: 15px; border-radius: 12px;">
                            <div class="stat-number" style="font-size: 32px;">${badge.iconUrl}</div>
                            <div class="stat-label" style="color: #fff; font-weight: bold; margin-top: 5px;">
                                ${badge.name}</div>
                            <div style="font-size: 11px; color: #9ca3af; margin-top: 3px;">${badge.description}</div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty badges}">
                        <div style="grid-column: 1 / -1; text-align: center; color: #9ca3af; padding: 20px;">
                            You haven't earned any badges yet. Complete learning modules to earn them!
                        </div>
                    </c:if>
                </div>

                <!-- Quick Stats -->
                <div class="quick-stats">
                    <div class="stat-item">
                        <div class="stat-number">${assessmentCount}</div>
                        <div class="stat-label">Assessments Done</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${coursesCompleted}</div>
                        <div class="stat-label">Courses Completed</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${forumPosts}</div>
                        <div class="stat-label">Forum Posts</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">${teleheathSessions}</div>
                        <div class="stat-label">Counselor Sessions</div>
                    </div>
                </div>

            </div>

            <script>
                // Toggle sidebar on mobile
                function toggleSidebar() {
                    document.getElementById('sidebar').classList.toggle('active');
                }

                // Logout function
                function logout() {
                    if (confirm('Are you sure you want to logout?')) {
                        window.location.href = '${pageContext.request.contextPath}/logout';
                    }
                }
            </script>
        </body>

        </html>