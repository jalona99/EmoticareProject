-- Fix Modules and Forum Script
-- Run this in pgAdmin

-- ==========================================
-- 1. Create Tables (IF NOT EXISTS)
-- ==========================================

-- Modules
CREATE TABLE IF NOT EXISTS modules (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    content_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Quizzes
CREATE TABLE IF NOT EXISTS quizzes (
    id SERIAL PRIMARY KEY,
    module_id INTEGER REFERENCES modules(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    passing_score INTEGER DEFAULT 70,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Quiz Questions
CREATE TABLE IF NOT EXISTS quiz_questions (
    id SERIAL PRIMARY KEY,
    quiz_id INTEGER REFERENCES quizzes(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    option_a VARCHAR(255) NOT NULL,
    option_b VARCHAR(255) NOT NULL,
    option_c VARCHAR(255) NOT NULL,
    option_d VARCHAR(255) NOT NULL,
    correct_option CHAR(1) CHECK (correct_option IN ('A', 'B', 'C', 'D')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Forum Posts
CREATE TABLE IF NOT EXISTS forum_posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    is_flagged BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Forum Comments
CREATE TABLE IF NOT EXISTS forum_comments (
    id SERIAL PRIMARY KEY,
    post_id INTEGER REFERENCES forum_posts(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Forum Likes
CREATE TABLE IF NOT EXISTS forum_likes (
    post_id INTEGER REFERENCES forum_posts(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (post_id, user_id)
);

-- User Progress (Tracking module completion)
CREATE TABLE IF NOT EXISTS user_progress (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    module_id INTEGER REFERENCES modules(id) ON DELETE CASCADE,
    status VARCHAR(20) CHECK (status IN ('IN_PROGRESS', 'COMPLETED')),
    quiz_score INTEGER,
    completed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 2. Grant Permissions (Crucial!)
-- ==========================================
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO emoticare_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO emoticare_user;

-- ==========================================
-- 3. Seed Sample Data
-- ==========================================

-- Seed Modules
INSERT INTO modules (title, description, content_url) VALUES
('Understanding Anxiety', 'Learn the basics of anxiety, its symptoms, and coping mechanisms.', 'https://www.youtube.com/embed/wwjDTtqG2TA'),
('Managing Stress', 'Effective strategies to manage daily stress and improve well-being.', 'https://www.youtube.com/embed/16p3B15fJm4')
ON CONFLICT DO NOTHING; -- No unique constraint on title, but duplicates won't break app

-- Seed Quizzes (assuming IDs 1 and 2 from above)
INSERT INTO quizzes (module_id, title) VALUES
(1, 'Anxiety Basics Quiz'),
(2, 'Stress Management Quiz');

-- Seed Questions for Quiz 1 (Anxiety)
INSERT INTO quiz_questions (quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option) VALUES
(1, 'What is a common physical symptom of anxiety?', 'Feeling calm', 'Rapid heartbeat', 'Slow breathing', 'Sleepiness', 'B'),
(1, 'Which is a recommended coping strategy?', 'Ignoring it', 'Deep breathing', 'Drinking caffeine', 'Isolating yourself', 'B');

-- Seed Forum Post
INSERT INTO forum_posts (user_id, title, content) VALUES
(1, 'Welcome to the Community!', 'Feel free to share your experiences and ask questions here. We are in this together.');
