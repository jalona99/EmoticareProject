-- Chat Sessions Table
CREATE TABLE public.chat_sessions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES public.users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Chat Messages Table
CREATE TABLE public.chat_messages (
    id SERIAL PRIMARY KEY,
    session_id INTEGER REFERENCES public.chat_sessions(id) ON DELETE CASCADE,
    sender VARCHAR(10) NOT NULL CHECK (sender IN ('USER', 'AI')),
    content TEXT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE public.chat_sessions OWNER TO emoticare_user;
ALTER TABLE public.chat_messages OWNER TO emoticare_user;
