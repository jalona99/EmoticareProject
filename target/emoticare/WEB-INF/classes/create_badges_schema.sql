-- ==========================================
-- Create Badges Tables
-- Run this in pgAdmin
-- ==========================================

-- 1. Badges Table
CREATE TABLE IF NOT EXISTS badges (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon_url VARCHAR(255),
    criteria_module_id INTEGER, -- If NULL, manual award only. If set, auto-award on module completion.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. User Badges (Mapping Table)
CREATE TABLE IF NOT EXISTS user_badges (
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    badge_id INTEGER REFERENCES badges(id) ON DELETE CASCADE,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, badge_id)
);

-- 3. Grant Permissions
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO emoticare_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO emoticare_user;

-- 4. Seed Sample Badges (Optional)
INSERT INTO badges (name, description, icon_url, criteria_module_id) VALUES
('Anxiety Warrior', 'Successfully completed the Understanding Anxiety module.', '🛡️', 1),
('Zen Master', 'Completed the Stress Management module.', '🧘', 2);
