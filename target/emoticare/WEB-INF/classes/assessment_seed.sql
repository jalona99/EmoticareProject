-- Create Assessment Types Table
CREATE TABLE IF NOT EXISTS assessment_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    code VARCHAR(20) UNIQUE NOT NULL, -- e.g. GAD-7, PHQ-9
    total_questions INTEGER DEFAULT 0,
    min_score DOUBLE PRECISION DEFAULT 0,
    max_score DOUBLE PRECISION DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert Default Assessments (Anxiety & Depression)
INSERT INTO assessment_types (id, name, description, code, total_questions, min_score, max_score) VALUES 
(1, 'Generalized Anxiety Disorder 7 (GAD-7)', 'Screening tool for generalized anxiety disorder.', 'GAD-7', 7, 0, 21),
(2, 'Patient Health Questionnaire 9 (PHQ-9)', 'Screening tool for depression severity.', 'PHQ-9', 9, 0, 27)
ON CONFLICT (id) DO NOTHING;
