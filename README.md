1. Modules and Use Cases
User Management Module
Registration: Users can register an account.
Login/Logout: Secure authentication.
Admin User Management: Admin can view and manage user accounts.
Assessment (Wellness) Module
Take Assessment: Students can take mental health assessments (PHQ-9, GAD-7).
View Results: Real-time feedback and score interpretation.
Admin assessment Management: CRUD operations for questions and assessment types.
Learning Module
Course Access: Students can view educational materials.
Admin Content Management: Admin can update learning materials.
Community & AI Support
Peer Forum: Discussion board for students.
AI Chatbot: Immediate AI assistance (powered by Gemini).
Telehealth: Appointment scheduling system.
2. Use Case Specification (Flow Example: Taking an Assessment)
Step	Actor Action	System Response
1	Selects "Self Assessment" from dashboard	Displays list of available assessments
2	Clicks on specific assessment (e.g., GAD-7)	Shows disclaimer and "Start" button
3	Answers each question	Validates that all questions are answered
4	Clicks "Submit"	Calculates score, saves to DB, and shows results
3. Technology Stack
Frontend
JSP (JavaServer Pages): Dynamic page rendering.
CSS3: Custom styling and Bootstrap for responsiveness.
JavaScript: Client-side validation and dynamic UI updates (AJAX).
JSTL: Tag library for backend-to-frontend data binding.
Backend
Java 17: Core programming language.
Spring MVC: Framework for routing and request handling.
PostgreSQL: Relational database for persistent storage.
Spring JDBC Template: For database interactions.
Maven: Dependency and build management.
4. Development Prerequisites
JDK 17 or higher
Apache Tomcat 9.0+
PostgreSQL 14+
Maven 3.8+
IDE: VS Code or IntelliJ IDEA
