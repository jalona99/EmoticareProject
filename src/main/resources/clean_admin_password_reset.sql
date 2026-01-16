-- Reset admin password to "pass123" using bcrypt via pgcrypto
-- Run as a superuser if pgcrypto is not installed yet.
CREATE EXTENSION IF NOT EXISTS pgcrypto;

UPDATE public.users
SET password = crypt('pass123', gen_salt('bf', 12)),
    updated_at = NOW()
WHERE username = 'admin';
