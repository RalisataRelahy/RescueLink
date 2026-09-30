-- Supabase Database Schema for RescueLink

-- PROFILES
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  language TEXT DEFAULT 'fr',
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public profiles are viewable by everyone" ON public.profiles FOR SELECT USING (true);
CREATE POLICY "Users can insert/update their own profile" ON public.profiles FOR ALL USING (auth.uid() = id);

-- INCIDENTS
CREATE TABLE IF NOT EXISTS public.incidents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id TEXT NOT NULL,
  category TEXT NOT NULL,
  description TEXT NOT NULL,
  latitude DOUBLE PRECISION NOT NULL,
  longitude DOUBLE PRECISION NOT NULL,
  priority TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'reported',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  photo_url TEXT,
  people_affected INT DEFAULT 0,
  road_blocked BOOLEAN DEFAULT false
);

CREATE INDEX IF NOT EXISTS incidents_category_idx ON public.incidents(category);
CREATE INDEX IF NOT EXISTS incidents_priority_idx ON public.incidents(priority);
CREATE INDEX IF NOT EXISTS incidents_status_idx ON public.incidents(status);
CREATE INDEX IF NOT EXISTS incidents_created_at_idx ON public.incidents(created_at DESC);

ALTER TABLE public.incidents ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Incidents viewable by everyone" ON public.incidents FOR SELECT USING (true);
CREATE POLICY "Authenticated users can create incidents" ON public.incidents FOR INSERT WITH CHECK (true);

-- INCIDENT HISTORY
CREATE TABLE IF NOT EXISTS public.incident_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  incident_id UUID REFERENCES public.incidents(id) ON DELETE CASCADE,
  status TEXT NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  comment TEXT
);

ALTER TABLE public.incident_history ENABLE ROW LEVEL SECURITY;
CREATE POLICY "History viewable by everyone" ON public.incident_history FOR SELECT USING (true);
CREATE POLICY "History insertable by authenticated users" ON public.incident_history FOR INSERT WITH CHECK (true);

-- NOTIFICATIONS
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id TEXT NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  is_read BOOLEAN DEFAULT false
);

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users view own notifications" ON public.notifications FOR SELECT USING (auth.uid()::text = user_id);
