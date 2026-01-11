-- ==========================================
-- Retroactive Badge Award Script (FIXED)
-- Run this in pgAdmin query tool
-- ==========================================

-- 1. Insert badges for completed modules safely
-- Uses "WHERE NOT EXISTS" to avoid errors if the table lacks a Primary Key

INSERT INTO user_badges (user_id, badge_id, earned_at)
SELECT up.user_id, b.id, up.completed_at
FROM user_progress up
JOIN badges b ON b.criteria_module_id = up.module_id
WHERE up.status = 'COMPLETED'
AND NOT EXISTS (
    SELECT 1 FROM user_badges ub 
    WHERE ub.user_id = up.user_id AND ub.badge_id = b.id
);

-- 2. Verify Success
SELECT u.username, b.name as badge_name, ub.earned_at 
FROM user_badges ub
JOIN users u ON u.id = ub.user_id
JOIN badges b ON b.id = ub.badge_id
ORDER BY ub.earned_at DESC;

-- 3. (Recommended) Apply Constraint to prevent future issues
-- Run this line separately. It might fail if you already have duplicates.
-- ALTER TABLE user_badges ADD CONSTRAINT user_badges_pk PRIMARY KEY (user_id, badge_id);
