-- Database Fix Script
-- Run this in pgAdmin Query Tool

-- 1. Create Roles Table (if it doesn't exist)
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- 2. Insert Default Roles
INSERT INTO roles (id, name) VALUES 
(1, 'Student'),
(2, 'Faculty'),
(3, 'Professional'),
(4, 'Admin')
ON CONFLICT (id) DO NOTHING;

-- 3. Update Users Table (Add missing columns)
ALTER TABLE users 
ADD COLUMN IF NOT EXISTS role_id INTEGER REFERENCES roles(id) ON DELETE SET NULL,
ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE,
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- 4. Insert Default Users
-- Uses the hashed password for 'password123'
INSERT INTO users (username, password, email, role_id, is_active) VALUES 
('student', '$2a$12$X2agoYXrbfIaZR02xIQFU.ByskCiJw6.K3goUw/ZRNsUtyJSRKwo2', 'student@university.edu', 1, true),
('admin', '$2a$12$X2agoYXrbfIaZR02xIQFU.ByskCiJw6.K3goUw/ZRNsUtyJSRKwo2', 'admin@university.edu', 4, true)
ON CONFLICT (username) DO NOTHING;
