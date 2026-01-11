-- Fix Permissions Script
-- Run this in pgAdmin (connected as 'postgres' or superuser)

-- 1. Grant usage on schema
GRANT USAGE ON SCHEMA public TO emoticare_user;

-- 2. Grant access to all tables (current and future)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO emoticare_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO emoticare_user;

-- 3. Ensure future tables created by postgres are accessible
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO emoticare_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO emoticare_user;

-- 4. Specifically fix ownership (optional but recommended)
ALTER TABLE users OWNER TO emoticare_user;
ALTER TABLE roles OWNER TO emoticare_user;
ALTER TABLE assessment_types OWNER TO emoticare_user;
