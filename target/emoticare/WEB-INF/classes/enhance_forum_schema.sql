-- Add columns for soft delete and reporting
ALTER TABLE forum_posts ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN DEFAULT FALSE;
ALTER TABLE forum_posts ADD COLUMN IF NOT EXISTS report_reason TEXT;
ALTER TABLE forum_posts ADD COLUMN IF NOT EXISTS reported_by INT; -- User ID of reporter (optional, keeps last reporter for simplicity or just a flag)
ALTER TABLE forum_posts ADD COLUMN IF NOT EXISTS is_reported BOOLEAN DEFAULT FALSE;

-- Ensure is_flagged is consistent if it was already there (it was in DAO mapping but maybe not in DB in all versions)
-- ALTER TABLE forum_posts ADD COLUMN IF NOT EXISTS is_flagged BOOLEAN DEFAULT FALSE; 
-- (Assuming is_flagged was existing, I'll use is_reported as the main one or sync them)
