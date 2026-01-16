# Emoticare Project Documentation

## Overview
This document outlines the architectural components, use cases, and technical requirements for the **Emoticare platform**—a comprehensive mental health and wellness support system designed for students.

---

## 1. Modules and Use Cases

### 1.1 User Management Module

#### Registration
- **Description**: Users can create new accounts on the platform.
- **Key Features**:
  - Email validation and verification
  - Password strength requirements
  - User role assignment (Student, Admin, Practitioner)
  - Terms and conditions acceptance

#### Login/Logout
- **Description**: Secure authentication mechanism for platform access.
- **Key Features**:
  - Email and password authentication
  - Session management
  - Password reset functionality
  - Secure logout with session termination

#### Admin User Management
- **Description**: Administrative interface for managing user accounts.
- **Key Features**:
  - View all user accounts
  - Edit user information
  - Deactivate or delete accounts
  - View user activity logs
  - Assign or modify user roles

---

### 1.2 Assessment (Wellness) Module

#### Take Assessment
- **Description**: Students can complete standardized mental health assessments.
- **Supported Assessment Types**:
  - PHQ-9 (Patient Health Questionnaire-9) - Depression screening
  - GAD-7 (Generalized Anxiety Disorder-7) - Anxiety assessment
  - Additional custom assessments as needed
- **Key Features**:
  - Progress tracking (current question / total questions)
  - Save and resume functionality
  - Timed assessments (optional)
  - Disclaimer and informed consent

#### View Results
- **Description**: Real-time feedback and score interpretation.
- **Key Features**:
  - Immediate score calculation
  - Severity level interpretation (Minimal, Mild, Moderate, Severe)
  - Graphical representation of results
  - Historical assessment comparison
  - Downloadable result reports
  - Personalized recommendations based on scores

#### Admin Assessment Management
- **Description**: Administrative operations for assessment creation and maintenance.
- **Key Features**:
  - **Create**: Add new assessment types and questions
  - **Read**: View all assessments and question banks
  - **Update**: Modify existing assessments and scoring logic
  - **Delete**: Remove outdated assessments safely
  - Manage scoring algorithms
  - Version control for assessments

---

### 1.3 Learning Module

#### Course Access
- **Description**: Students can access educational materials and learning resources.
- **Key Features**:
  - Browse course catalog
  - Enroll in courses
  - Access learning materials (videos, PDFs, articles)
  - Track learning progress
  - Complete lessons and quizzes
  - Earn certificates upon completion

#### Admin Content Management
- **Description**: Administrative control over learning materials and course content.
- **Key Features**:
  - Upload and organize educational materials
  - Create and structure courses
  - Update course content and resources
  - Manage instructor assignments
  - Monitor content performance metrics
  - Schedule course availability

---

### 1.4 Community & AI Support

#### Peer Forum
- **Description**: Discussion board enabling student interaction and peer support.
- **Key Features**:
  - Create discussion threads
  - Reply to posts
  - Like and rate responses
  - Moderation tools for admins
  - Search and filter functionality
  - User profiles and reputation system

#### AI Chatbot
- **Description**: Intelligent virtual assistant providing immediate mental health support.
- **Integration**: Powered by Google Gemini API
- **Key Features**:
  - 24/7 availability
  - Natural language processing
  - Crisis resource recommendations
  - Conversation history
  - Escalation to human support when needed

#### Telehealth System
- **Description**: Appointment scheduling and virtual consultation platform.
- **Key Features**:
  - Browse available practitioners
  - Schedule appointments
  - Send appointment reminders
  - Video/audio consultation capabilities
  - Prescription and follow-up management
  - Secure messaging between appointments

---

## 2. Use Case Specification

### 2.1 Flow Example: Taking an Assessment

| Step | Actor | Action | System Response |
|------|-------|--------|-----------------|
| 1 | Student | Selects "Self Assessment" from dashboard | Displays list of available assessments (PHQ-9, GAD-7, etc.) |
| 2 | Student | Clicks on specific assessment (e.g., GAD-7) | Shows disclaimer and informed consent with "Start" button |
| 3 | Student | Answers each question (1-7 scale) | Validates that all questions are answered; blocks submission if incomplete |
| 4 | Student | Clicks "Submit" | Calculates score, saves response to database, displays results with interpretation |
| 5 | Student | Views Results | Shows severity level, graphical representation, and personalized recommendations |
| 6 | System | Background Process | Logs assessment completion for tracking and analytics |

#### Preconditions
- User is logged in as a Student
- Assessment has been published by Admin
- User has not already taken this assessment (or can retake based on settings)

#### Postconditions
- Assessment response is saved to database
- Result is available in user's history
- Recommendations are displayed to user

---

## 3. Technology Stack

### 3.1 Frontend

#### JSP (JavaServer Pages)
- **Purpose**: Dynamic server-side page rendering
- **Benefits**: 
  - Server-side Java code execution
  - Direct integration with backend logic
  - Efficient data binding with JSTL tags

#### CSS3
- **Purpose**: Styling and layout
- **Features**:
  - Custom styling for Emoticare branding
  - Bootstrap 5 integration for responsive design
  - Flexbox and Grid for modern layouts
  - Accessibility considerations (WCAG 2.1 compliance)

#### JavaScript
- **Purpose**: Client-side validation and dynamic UI enhancements
- **Key Capabilities**:
  - Form validation before submission
  - AJAX requests for asynchronous operations
  - DOM manipulation and event handling
  - Real-time user feedback and animations

#### JSTL (JavaServer Pages Standard Tag Library)
- **Purpose**: Tag-based backend-to-frontend data binding
- **Benefits**:
  - Cleaner JSP syntax
  - Iteration over collections (forEach)
  - Conditional rendering (if/choose)
  - Variable management

### 3.2 Backend

#### Java 17
- **Purpose**: Core programming language
- **Features**:
  - Modern language features (Records, Sealed Classes, Pattern Matching)
  - Strong type safety
  - Object-oriented design
  - Large ecosystem and community support

#### Spring MVC
- **Purpose**: Web application framework for routing and request handling
- **Components**:
  - **DispatcherServlet**: Front controller for request routing
  - **Controllers**: Handle HTTP requests and business logic
  - **Models**: Data transfer between controller and view
  - **Views**: JSP templates for rendering

#### PostgreSQL
- **Purpose**: Relational database for persistent data storage
- **Key Features**:
  - ACID compliance for data integrity
  - Support for complex queries
  - JSON support for flexible data structures
  - Excellent reliability and performance

#### Spring JDBC Template
- **Purpose**: Database interaction and query execution
- **Benefits**:
  - Simplifies JDBC code
  - Automatic resource management
  - Exception handling
  - Support for parameterized queries (SQL injection prevention)

#### Maven
- **Purpose**: Build automation and dependency management
- **Functions**:
  - Compile Java source code
  - Manage project dependencies
  - Run unit tests
  - Package application (WAR file for deployment)

---

## 4. Development Prerequisites

### 4.1 System Requirements

| Requirement | Minimum Version | Recommended Version |
|-------------|-----------------|-------------------|
| **JDK** | 17 | 17+ (LTS) |
| **Apache Tomcat** | 9.0 | 10.1+ |
| **PostgreSQL** | 14 | 15+ |
| **Maven** | 3.8 | 3.9+ |

### 4.2 Development Environment

#### IDE Options
- **VS Code** (Lightweight, extensions available)
  - Recommended extensions:
    - Extension Pack for Java
    - Spring Boot Extension Pack
    - PostgreSQL Explorer
    - REST Client

- **IntelliJ IDEA** (Full-featured)
  - Community Edition (free)
  - Ultimate Edition (paid, with Spring support)

#### Additional Tools
- **Git**: Version control
- **Postman/Insomnia**: API testing
- **pgAdmin or DBeaver**: Database management GUI
- **Docker** (optional): Containerized development environment

### 4.3 Installation Steps

#### 1. Install JDK 17
```bash
# Windows
# Download from oracle.com or use:
choco install openjdk17

# macOS
brew install openjdk@17

# Linux
sudo apt install openjdk-17-jdk
```

#### 2. Install Apache Tomcat
```bash
# Download from tomcat.apache.org
# Extract to preferred location
# Set CATALINA_HOME environment variable
```

#### 3. Install PostgreSQL
```bash
# Windows/macOS
# Download installer from postgresql.org

# Linux
sudo apt install postgresql postgresql-contrib
```

#### 4. Install Maven
```bash
# Download from maven.apache.org
# Add to PATH environment variable
# Verify: mvn --version
```

---

## 5. Project Structure

```
emoticare/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/emoticare/
│   │   │       ├── controller/
│   │   │       ├── service/
│   │   │       ├── repository/
│   │   │       ├── model/
│   │   │       └── util/
│   │   ├── resources/
│   │   │   ├── application.properties
│   │   │   └── static/
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── views/
│   │       │   └── web.xml
│   │       ├── css/
│   │       ├── js/
│   │       └── images/
│   └── test/
│       ├── java/
│       └── resources/
├── pom.xml
├── README.md
└── .gitignore
```

---

## 6. Database Schema Overview

### Core Tables

#### users
- `user_id`: Primary key
- `email`: Unique identifier
- `password_hash`: Encrypted password
- `full_name`: User's full name
- `role`: User role (STUDENT, ADMIN, PRACTITIONER)
- `created_at`: Account creation timestamp
- `updated_at`: Last update timestamp

#### assessments
- `assessment_id`: Primary key
- `title`: Assessment name (e.g., "GAD-7")
- `description`: Assessment details
- `type`: Assessment category
- `created_by`: Admin who created it
- `created_at`: Timestamp

#### assessment_questions
- `question_id`: Primary key
- `assessment_id`: Foreign key
- `question_text`: Question content
- `question_order`: Display order
- `score_weight`: Scoring contribution

#### assessment_responses
- `response_id`: Primary key
- `user_id`: Foreign key
- `assessment_id`: Foreign key
- `responses`: JSON array of answers
- `score`: Calculated total score
- `severity_level`: Interpretation (Minimal/Mild/Moderate/Severe)
- `completed_at`: Completion timestamp

#### courses
- `course_id`: Primary key
- `title`: Course name
- `description`: Course overview
- `created_by`: Instructor
- `is_published`: Availability status

#### enrollments
- `enrollment_id`: Primary key
- `user_id`: Foreign key
- `course_id`: Foreign key
- `enrolled_at`: Enrollment date
- `completion_status`: Progress tracking

---

## 7. API Endpoints (Overview)

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `POST /api/auth/logout` - User logout

### Assessments
- `GET /api/assessments` - List all assessments
- `GET /api/assessments/{id}` - Get specific assessment
- `POST /api/assessments/{id}/submit` - Submit assessment response
- `GET /api/assessments/results/{responseId}` - Retrieve results

### Learning
- `GET /api/courses` - List courses
- `GET /api/courses/{id}` - Course details
- `POST /api/courses/{id}/enroll` - Enroll in course

### Community
- `GET /api/forum/threads` - List forum threads
- `POST /api/forum/threads` - Create new thread
- `POST /api/forum/replies` - Add reply to thread

---

## 8. Security Considerations

### Authentication & Authorization
- Implement Spring Security for authentication
- Use JWT (JSON Web Tokens) for API security
- Role-based access control (RBAC)
- Session timeout after inactivity

### Data Protection
- Hash passwords using bcrypt or Argon2
- Encrypt sensitive data in database
- Use HTTPS/TLS for all communications
- Implement SQL injection prevention (parameterized queries)
- CSRF token protection on forms

### Privacy
- GDPR compliance for data handling
- Data encryption in transit and at rest
- Secure file upload validation
- Regular security audits

---

## 9. Development Workflow

### Setup
```bash
# Clone repository
git clone <repository-url>

# Navigate to project
cd emoticare

# Install dependencies
mvn clean install

# Configure application.properties with database credentials
```

### Running Locally
```bash
# Option 1: Using Maven
mvn spring-boot:run

# Option 2: Using IDE run configuration
# Or deploy WAR to Tomcat

# Access application
# http://localhost:8080/emoticare
```

### Testing
```bash
# Run unit tests
mvn test

# Run integration tests
mvn verify
```

---

## 10. Deployment

### Production Environment
- Server: Linux (Ubuntu 20.04 LTS or later)
- Web Server: Apache or Nginx (reverse proxy)
- Application Server: Apache Tomcat
- Database: PostgreSQL (separate server)
- SSL/TLS certificates for HTTPS

### Docker Deployment (Optional)
```dockerfile
# Dockerfile example
FROM openjdk:17-jdk-slim
COPY target/emoticare.war /app.war
ENTRYPOINT ["java", "-jar", "/app.war"]
```

---

## 11. Testing Strategy

### Unit Testing
- Test service layer methods
- Mock repository dependencies
- JUnit 5 with Mockito

### Integration Testing
- Test controller endpoints
- Database integration tests
- Spring Test framework

### End-to-End Testing
- Selenium for UI testing
- Postman collections for API testing

---

## 12. Monitoring & Logging

### Logging
- Use Log4j2 or Logback
- Log levels: DEBUG, INFO, WARN, ERROR
- Structured logging for analysis

### Monitoring
- Application health checks
- Database connection pooling monitoring
- Error rate tracking
- Performance metrics

---

## 13. Future Enhancements

- Mobile application (iOS/Android)
- Advanced analytics dashboard
- Machine learning for personalized recommendations
- Video consultation integration
- Prescription management system
- Multi-language support

---

## 14. Contact & Support

For questions or support regarding the Emoticare project:
- **Project Lead**: [Contact Information]
- **Documentation**: [Link to Wiki/Docs]
- **Issue Tracker**: [GitHub Issues/Jira]

---

## 15. Version History

| Version | Date | Description |
|---------|------|-------------|
| 1.0 | January 2026 | Initial documentation |

---

**Last Updated**: January 16, 2026  
**Status**: Active Development


