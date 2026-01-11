-- 1. Create Roles Table (if not exists)
CREATE TABLE IF NOT EXISTS roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- 2. Create Users Table (if not exists)
-- Matching UserDAO fields: id, username, email, password, role_id, is_active
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL, -- BCrypt Hash
    role_id INTEGER REFERENCES roles(id) ON DELETE SET NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Insert Default Roles
INSERT INTO roles (id, name) VALUES 
(1, 'Student'),
(2, 'Faculty'),
(3, 'Professional'),
(4, 'Admin')
ON CONFLICT (id) DO NOTHING; -- Avoid error if IDs exist

-- 4. Insert Default Users
-- Password is 'password123'
INSERT INTO users (username, password, email, role_id, is_active) VALUES 
('student', '$2a$12$X2agoYXrbfIaZR02xIQFU.ByskCiJw6.K3goUw/ZRNsUtyJSRKwo2', 'student@university.edu', 1, true),
('admin', '$2a$12$X2agoYXrbfIaZR02xIQFU.ByskCiJw6.K3goUw/ZRNsUtyJSRKwo2', 'admin@university.edu', 4, true)
ON CONFLICT (username) DO NOTHING;
