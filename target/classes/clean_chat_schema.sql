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

-- Chat Risk Alerts Table (no chat content stored)
CREATE TABLE public.chat_risk_alerts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES public.users(id) ON DELETE CASCADE,
    session_id INTEGER REFERENCES public.chat_sessions(id) ON DELETE SET NULL,
    trigger VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    acknowledged BOOLEAN NOT NULL DEFAULT FALSE,
    acknowledged_at TIMESTAMP WITHOUT TIME ZONE
);

ALTER TABLE public.chat_sessions OWNER TO emoticare_user;
ALTER TABLE public.chat_messages OWNER TO emoticare_user;
ALTER TABLE public.chat_risk_alerts OWNER TO emoticare_user;
