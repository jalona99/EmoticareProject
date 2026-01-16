-- Telehealth Professional Profiles Table
CREATE TABLE public.professional_profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES public.users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    credentials VARCHAR(255),
    specialty VARCHAR(255),
    bio TEXT,
    calendly_url TEXT NOT NULL
);

ALTER TABLE public.professional_profiles OWNER TO emoticare_user;

-- Insert Professionals into users table (Role ID 3 is Professional)
-- Password is 'ExpertPass123!' (BCrypt: $2a$12$R.O4Y1O3kO.P3qP4R5S6T7U8V9W0X1Y2Z3A4B5C6D7E8F9G0H1I2J)
-- Using dummy BCrypt for now, user can reset or use their own.
INSERT INTO public.users (username, email, password, role_id, is_active) VALUES 
('sjenkins', 'sarah.jenkins@emoticare.com', '$2a$12$X2agoYXrbfIaZR02xIQFU.ByskCiJw6.K3goUw/ZRNsUtyJSRKwo2', 3, true),
('mchen', 'michael.chen@emoticare.com', '$2a$12$X2agoYXrbfIaZR02xIQFU.ByskCiJw6.K3goUw/ZRNsUtyJSRKwo2', 3, true);

-- Insert into professional_profiles
INSERT INTO public.professional_profiles (user_id, name, credentials, specialty, bio, calendly_url) VALUES 
(
    (SELECT id FROM users WHERE username = 'sjenkins'),
    'Dr. Sarah Jenkins',
    'PhD, Clinical Psychologist',
    'Anxiety & Depression Management',
    'Dr. Jenkins has over 12 years of experience in clinical psychology, specializing in mood disorders and helping students navigate academic pressure.',
    'https://calendly.com/taqiatahmida/emoticare-mental-health-professional-1?background_color=add6f5&primary_color=603de1'
),
(
    (SELECT id FROM users WHERE username = 'mchen'),
    'Prof. Michael Chen',
    'MD, Psychiatrist',
    'CBT & Stress Management',
    'Prof. Chen focuses on Cognitive Behavioral Therapy and evidence-based stress reduction techniques for young adults.',
    'https://calendly.com/taqiatahmida/30min?background_color=bbe0f8&primary_color=5d26e8'
);
