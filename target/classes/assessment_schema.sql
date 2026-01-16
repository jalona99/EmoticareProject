-- Assessment schema and seed data

CREATE TABLE IF NOT EXISTS public.assessments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    assessment_type_id INTEGER NOT NULL REFERENCES public.assessment_types(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    total_score DOUBLE PRECISION DEFAULT 0,
    risk_level VARCHAR(20),
    started_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITHOUT TIME ZONE,
    updated_at TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS public.assessment_questions (
    id SERIAL PRIMARY KEY,
    assessment_type_id INTEGER NOT NULL REFERENCES public.assessment_types(id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    question_order INTEGER NOT NULL,
    question_code VARCHAR(32),
    reverse_scored BOOLEAN DEFAULT FALSE
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_assessment_questions_type_order
    ON public.assessment_questions(assessment_type_id, question_order);

CREATE TABLE IF NOT EXISTS public.question_scales (
    id SERIAL PRIMARY KEY,
    assessment_question_id INTEGER NOT NULL REFERENCES public.assessment_questions(id) ON DELETE CASCADE,
    scale_value INTEGER NOT NULL,
    scale_label VARCHAR(255) NOT NULL,
    scale_order INTEGER NOT NULL,
    UNIQUE (assessment_question_id, scale_value)
);

CREATE TABLE IF NOT EXISTS public.assessment_responses (
    id SERIAL PRIMARY KEY,
    assessment_id INTEGER NOT NULL REFERENCES public.assessments(id) ON DELETE CASCADE,
    question_id INTEGER NOT NULL REFERENCES public.assessment_questions(id) ON DELETE CASCADE,
    scale_value INTEGER NOT NULL,
    responded_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (assessment_id, question_id)
);

ALTER TABLE public.assessments OWNER TO emoticare_user;
ALTER TABLE public.assessment_questions OWNER TO emoticare_user;
ALTER TABLE public.question_scales OWNER TO emoticare_user;
ALTER TABLE public.assessment_responses OWNER TO emoticare_user;

-- Seed PSS-10 Assessment Type
INSERT INTO public.assessment_types (id, name, description, code, total_questions, min_score, max_score)
VALUES (3, 'Perceived Stress Scale (PSS-10)', 'Tool to measure the perception of stress.', 'PSS-10', 10, 0, 40)
ON CONFLICT (id) DO NOTHING;

-- Seed questions (GAD-7, PHQ-9, PSS-10)
INSERT INTO public.assessment_questions (id, assessment_type_id, question_text, question_order, question_code, reverse_scored)
VALUES
    (1, 1, 'Feeling nervous, anxious, or on edge', 1, 'GAD7_1', FALSE),
    (2, 1, 'Not being able to stop or control worrying', 2, 'GAD7_2', FALSE),
    (3, 1, 'Worrying too much about different things', 3, 'GAD7_3', FALSE),
    (4, 1, 'Trouble relaxing', 4, 'GAD7_4', FALSE),
    (5, 1, 'Being so restless that it is hard to sit still', 5, 'GAD7_5', FALSE),
    (6, 1, 'Becoming easily annoyed or irritable', 6, 'GAD7_6', FALSE),
    (7, 1, 'Feeling afraid as if something awful might happen', 7, 'GAD7_7', FALSE),
    (8, 2, 'Little interest or pleasure in doing things', 1, 'PHQ9_1', FALSE),
    (9, 2, 'Feeling down, depressed, or hopeless', 2, 'PHQ9_2', FALSE),
    (10, 2, 'Trouble falling or staying asleep, or sleeping too much', 3, 'PHQ9_3', FALSE),
    (11, 2, 'Feeling tired or having little energy', 4, 'PHQ9_4', FALSE),
    (12, 2, 'Poor appetite or overeating', 5, 'PHQ9_5', FALSE),
    (13, 2, 'Feeling bad about yourself - or that you are a failure or have let yourself or your family down', 6, 'PHQ9_6', FALSE),
    (14, 2, 'Trouble concentrating on things, such as reading or watching television', 7, 'PHQ9_7', FALSE),
    (15, 2, 'Moving or speaking slowly that others could have noticed, or being fidgety or restless', 8, 'PHQ9_8', FALSE),
    (16, 2, 'Thoughts that you would be better off dead or of hurting yourself in some way', 9, 'PHQ9_9', FALSE),
    (17, 3, 'In the last month, how often have you been upset because of something that happened unexpectedly?', 1, 'PSS10_1', FALSE),
    (18, 3, 'In the last month, how often have you felt that you were unable to control the important things in your life?', 2, 'PSS10_2', FALSE),
    (19, 3, 'In the last month, how often have you felt nervous and "stressed"?', 3, 'PSS10_3', FALSE),
    (20, 3, 'In the last month, how often have you felt confident about your ability to handle your personal problems?', 4, 'PSS10_4', TRUE),
    (21, 3, 'In the last month, how often have you felt that things were going your way?', 5, 'PSS10_5', TRUE),
    (22, 3, 'In the last month, how often have you found that you could not cope with all the things that you had to do?', 6, 'PSS10_6', FALSE),
    (23, 3, 'In the last month, how often have you been able to control irritations in your life?', 7, 'PSS10_7', TRUE),
    (24, 3, 'In the last month, how often have you felt that you were on top of things?', 8, 'PSS10_8', TRUE),
    (25, 3, 'In the last month, how often have you been angered because of things that were outside of your control?', 9, 'PSS10_9', FALSE),
    (26, 3, 'In the last month, how often have you felt difficulties were piling up so high that you could not overcome them?', 10, 'PSS10_10', FALSE)
ON CONFLICT (id) DO NOTHING;

-- Seed scales for GAD-7 and PHQ-9 (0-3)
DO $$
DECLARE
    q_id INT;
BEGIN
    FOR q_id IN 1..16 LOOP
        INSERT INTO public.question_scales (assessment_question_id, scale_value, scale_label, scale_order)
        VALUES 
            (q_id, 0, 'Not at all', 1),
            (q_id, 1, 'Several days', 2),
            (q_id, 2, 'More than half the days', 3),
            (q_id, 3, 'Nearly every day', 4)
        ON CONFLICT (assessment_question_id, scale_value) DO NOTHING;
    END LOOP;
END $$;

-- Seed scales for PSS-10 (0-4)
DO $$
DECLARE
    q_id INT;
BEGIN
    FOR q_id IN 17..26 LOOP
        INSERT INTO public.question_scales (assessment_question_id, scale_value, scale_label, scale_order)
        VALUES 
            (q_id, 0, 'Never', 1),
            (q_id, 1, 'Almost Never', 2),
            (q_id, 2, 'Sometimes', 3),
            (q_id, 3, 'Fairly Often', 4),
            (q_id, 4, 'Very Often', 5)
        ON CONFLICT (assessment_question_id, scale_value) DO NOTHING;
    END LOOP;
END $$;

SELECT setval(pg_get_serial_sequence('public.assessment_questions', 'id'),
              COALESCE((SELECT MAX(id) FROM public.assessment_questions), 1),
              true);
SELECT setval(pg_get_serial_sequence('public.question_scales', 'id'),
              COALESCE((SELECT MAX(id) FROM public.question_scales), 1),
              true);
