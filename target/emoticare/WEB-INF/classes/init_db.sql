-- Database Initialization Script
-- Run this in pgAdmin Query Tool connected as 'postgres' (superuser)

-- 1. Create User (if not exists, this block handles it safely)
DO
$do$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles
      WHERE  rolname = 'emoticare_user') THEN

      CREATE ROLE emoticare_user WITH LOGIN PASSWORD 'SecurePassword123!';
   END IF;
END
$do$;

-- 2. Create Database
-- NOTE: If this fails saying "database already exists", you can ignore the error.
-- PostgreSQL does not support 'CREATE DATABASE IF NOT EXISTS' natively in all versions inside blocks.
CREATE DATABASE emoticare_db OWNER emoticare_user;

-- 3. Grant Privileges
GRANT ALL PRIVILEGES ON DATABASE emoticare_db TO emoticare_user;
