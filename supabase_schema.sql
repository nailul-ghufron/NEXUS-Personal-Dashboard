-- =============================================
-- NEXUS - Supabase Database Schema
-- Updated: April 2026
-- =============================================

-- 1. Table: profiles (Extends Supabase Auth)
CREATE TABLE profiles (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  full_name TEXT,
  nim TEXT,
  major TEXT,
  semester TEXT,
  avatar_url TEXT,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Table: schedules
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

-- 3. Table: checklist_items
CREATE TABLE checklist_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  is_completed BOOLEAN DEFAULT FALSE,
  category TEXT DEFAULT 'daily', -- daily, weekly, custom
  sort_order INTEGER DEFAULT 0,
  due_date TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Table: notes
CREATE TABLE notes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  content TEXT,
  tint TEXT DEFAULT 'neutral',
  last_modified TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS for all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE checklist_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE notes ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Users can view own profile" ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can manage own schedules" ON schedules FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own checklist_items" ON checklist_items FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Users can manage own notes" ON notes FOR ALL USING (auth.uid() = user_id);

-- Trigger to create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, avatar_url)
  VALUES (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
