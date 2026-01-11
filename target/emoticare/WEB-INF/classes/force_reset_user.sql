-- Force Reset User Script
-- Run this in pgAdmin to fix the specific user record

-- 1. Ensure the user exists (if not, insert it)
INSERT INTO users (username, password, email, role_id, is_active) 
VALUES ('student', 'placeholder', 'student@university.edu', 1, true)
ON CONFLICT (username) DO NOTHING;

-- 2. Force UPDATE the password and role
-- This overwrites whatever was there before
UPDATE users 
SET 
    password = '$2a$12$X2agoYXrbfIaZR02xIQFU.ByskCiJw6.K3goUw/ZRNsUtyJSRKwo2', -- Hash for 'password123'
    role_id = 1,
    is_active = true
WHERE username = 'student';

-- 3. Validation Query (Optional - run this separately if you want to see the result)
-- SELECT id, username, role_id, is_active FROM users WHERE username = 'student';
