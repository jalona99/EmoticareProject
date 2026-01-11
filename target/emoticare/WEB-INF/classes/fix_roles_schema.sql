-- Fix Roles Table Script
-- Run this in pgAdmin

-- 1. Add description column
ALTER TABLE roles 
ADD COLUMN IF NOT EXISTS description VARCHAR(255);

-- 2. Update existing roles with descriptions
UPDATE roles SET description = 'Undergraduate or graduate student' WHERE name = 'Student';
UPDATE roles SET description = 'Academic faculty member' WHERE name = 'Faculty';
UPDATE roles SET description = 'Mental health professional' WHERE name = 'Professional';
UPDATE roles SET description = 'System administrator' WHERE name = 'Admin';
