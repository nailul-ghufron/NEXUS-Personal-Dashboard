-- =============================================
-- SQL Script to Clean Duplicate Data and Add Unique Constraints
-- =============================================

-- 1. Clean Duplicates from 'schedules'
-- Keeps the one with the earliest created_at or id
DELETE FROM schedules a
USING schedules b
WHERE a.id > b.id 
  AND a.user_id = b.user_id 
  AND a.title = b.title 
  AND a.day_of_week = b.day_of_week 
  AND a.start_time = b.start_time;

-- 2. Clean Duplicates from 'checklist_items'
DELETE FROM checklist_items a
USING checklist_items b
WHERE a.id > b.id 
  AND a.user_id = b.user_id 
  AND a.title = b.title 
  AND a.category = b.category;

-- 3. Add Unique Constraints to prevent future duplicates
-- This will ensure that an error is thrown if a duplicate is attempted
-- Or allows using ON CONFLICT in the future

-- For schedules
ALTER TABLE schedules 
ADD CONSTRAINT unique_schedule_item 
UNIQUE (user_id, title, day_of_week, start_time);

-- For checklist_items
ALTER TABLE checklist_items 
ADD CONSTRAINT unique_checklist_item 
UNIQUE (user_id, title, category);

-- Note: If you have legitimate reasons to have items with the same name,
-- you might want to adjust these constraints. 
-- But for a personal dashboard, these are usually duplicates.
