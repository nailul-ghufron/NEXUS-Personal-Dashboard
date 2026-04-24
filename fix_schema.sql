-- =============================================
-- Migration: Add missing columns to Profiles
-- =============================================

ALTER TABLE profiles ADD COLUMN IF NOT EXISTS nim TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS major TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS semester TEXT;

-- =============================================
-- Migration: Update Schedules Table
-- =============================================

-- We rename the old table to backup just in case
ALTER TABLE IF EXISTS schedules RENAME TO schedules_old;

CREATE TABLE schedules (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  day_of_week INTEGER NOT NULL, -- 0=Sen, 1=Sel, 2=Rab, 3=Kam, 4=Jum, 5=Sab, 6=Min
  start_time TEXT NOT NULL,      -- Format: HH:mm
  end_time TEXT,               -- Format: HH:mm (can be NULL)
  type TEXT CHECK (type IN ('campus', 'mahad', 'other')) DEFAULT 'campus',
  location TEXT,
  lecturer TEXT,
  sks INTEGER,
  class_group TEXT,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE schedules ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users can manage own schedules" ON schedules FOR ALL USING (auth.uid() = user_id);

-- =============================================
-- Migration: Update Checklist Table
-- =============================================

-- Rename checklists to checklist_items if it exists
ALTER TABLE IF EXISTS checklists RENAME TO checklist_items;

-- Add missing columns if they don't exist
ALTER TABLE checklist_items ADD COLUMN IF NOT EXISTS category TEXT DEFAULT 'daily';
ALTER TABLE checklist_items ADD COLUMN IF NOT EXISTS sort_order INTEGER DEFAULT 0;

-- Ensure RLS is enabled and policy exists
ALTER TABLE checklist_items ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "Users can manage own checklists" ON checklist_items;
CREATE POLICY "Users can manage own checklist_items" ON checklist_items FOR ALL USING (auth.uid() = user_id);
