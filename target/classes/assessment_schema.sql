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

-- Seed questions (GAD-7, PHQ-9)
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
    (16, 2, 'Thoughts that you would be better off dead or of hurting yourself in some way', 9, 'PHQ9_9', FALSE)
ON CONFLICT (id) DO NOTHING;

-- Seed scales
INSERT INTO public.question_scales (id, assessment_question_id, scale_value, scale_label, scale_order)
VALUES
    (1, 1, 0, 'Not at all', 1),
    (2, 1, 1, 'Several days', 2),
    (3, 1, 2, 'More than half the days', 3),
    (4, 1, 3, 'Nearly every day', 4),
    (5, 2, 0, 'Not at all', 1),
    (6, 2, 1, 'Several days', 2),
    (7, 2, 2, 'More than half the days', 3),
    (8, 2, 3, 'Nearly every day', 4),
    (9, 3, 0, 'Not at all', 1),
    (10, 3, 1, 'Several days', 2),
    (11, 3, 2, 'More than half the days', 3),
    (12, 3, 3, 'Nearly every day', 4),
    (13, 4, 0, 'Not at all', 1),
    (14, 4, 1, 'Several days', 2),
    (15, 4, 2, 'More than half the days', 3),
    (16, 4, 3, 'Nearly every day', 4),
    (17, 5, 0, 'Not at all', 1),
    (18, 5, 1, 'Several days', 2),
    (19, 5, 2, 'More than half the days', 3),
    (20, 5, 3, 'Nearly every day', 4),
    (21, 6, 0, 'Not at all', 1),
    (22, 6, 1, 'Several days', 2),
    (23, 6, 2, 'More than half the days', 3),
    (24, 6, 3, 'Nearly every day', 4),
    (25, 7, 0, 'Not at all', 1),
    (26, 7, 1, 'Several days', 2),
    (27, 7, 2, 'More than half the days', 3),
    (28, 7, 3, 'Nearly every day', 4),
    (29, 8, 0, 'Not at all', 1),
    (30, 8, 1, 'Several days', 2),
    (31, 8, 2, 'More than half the days', 3),
    (32, 8, 3, 'Nearly every day', 4),
    (33, 9, 0, 'Not at all', 1),
    (34, 9, 1, 'Several days', 2),
    (35, 9, 2, 'More than half the days', 3),
    (36, 9, 3, 'Nearly every day', 4),
    (37, 10, 0, 'Not at all', 1),
    (38, 10, 1, 'Several days', 2),
    (39, 10, 2, 'More than half the days', 3),
    (40, 10, 3, 'Nearly every day', 4),
    (41, 11, 0, 'Not at all', 1),
    (42, 11, 1, 'Several days', 2),
    (43, 11, 2, 'More than half the days', 3),
    (44, 11, 3, 'Nearly every day', 4),
    (45, 12, 0, 'Not at all', 1),
    (46, 12, 1, 'Several days', 2),
    (47, 12, 2, 'More than half the days', 3),
    (48, 12, 3, 'Nearly every day', 4),
    (49, 13, 0, 'Not at all', 1),
    (50, 13, 1, 'Several days', 2),
    (51, 13, 2, 'More than half the days', 3),
    (52, 13, 3, 'Nearly every day', 4),
    (53, 14, 0, 'Not at all', 1),
    (54, 14, 1, 'Several days', 2),
    (55, 14, 2, 'More than half the days', 3),
    (56, 14, 3, 'Nearly every day', 4),
    (57, 15, 0, 'Not at all', 1),
    (58, 15, 1, 'Several days', 2),
    (59, 15, 2, 'More than half the days', 3),
    (60, 15, 3, 'Nearly every day', 4),
    (61, 16, 0, 'Not at all', 1),
    (62, 16, 1, 'Several days', 2),
    (63, 16, 2, 'More than half the days', 3),
    (64, 16, 3, 'Nearly every day', 4)
ON CONFLICT (id) DO NOTHING;

SELECT setval(pg_get_serial_sequence('public.assessment_questions', 'id'),
              COALESCE((SELECT MAX(id) FROM public.assessment_questions), 1),
              true);
SELECT setval(pg_get_serial_sequence('public.question_scales', 'id'),
              COALESCE((SELECT MAX(id) FROM public.question_scales), 1),
              true);
