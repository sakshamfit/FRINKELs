-- Create documentation table for FRINKELS knowledge base

-- Create the documentation table
CREATE TABLE IF NOT EXISTS public.documentation (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    tags TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_published BOOLEAN DEFAULT TRUE
);

-- Enable real-time for the documentation table
ALTER TABLE public.documentation REPLICA IDENTITY FULL;

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_documentation_category ON public.documentation(category);
CREATE INDEX IF NOT EXISTS idx_documentation_is_published ON public.documentation(is_published);
CREATE INDEX IF NOT EXISTS idx_documentation_created_at ON public.documentation(created_at DESC);

-- Create trigger to automatically update updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TRIGGER IF EXISTS update_documentation_updated_at ON public.documentation;
CREATE TRIGGER update_documentation_updated_at
    BEFORE UPDATE ON public.documentation
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (RLS)
ALTER TABLE public.documentation ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for documentation table
-- Policy: Anyone can read published documentation
CREATE POLICY "Anyone can read published documentation" ON public.documentation
    FOR SELECT
    USING (is_published = TRUE);

-- Policy: Authenticated users can read their own unpublished documentation
CREATE POLICY "Users can read own unpublished documentation" ON public.documentation
    FOR SELECT
    USING (
        auth.role() = 'authenticated' AND
        is_published = FALSE
    );

-- Policy: Only authenticated users can create documentation
CREATE POLICY "Authenticated users can create documentation" ON public.documentation
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

-- Policy: Only authenticated users can update their own documentation
CREATE POLICY "Users can update own documentation" ON public.documentation
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

-- Policy: Only authenticated users can delete their own documentation
CREATE POLICY "Users can delete own documentation" ON public.documentation
    FOR DELETE
    USING (auth.role() = 'authenticated');

-- Insert some initial documentation records
INSERT INTO public.documentation (title, content, category, tags, is_published) VALUES
(
    'FRINKELS Platform Overview',
    'FRINKELS is a hyperlocal professional discovery platform that connects professionals with local businesses, communities, job opportunities, and knowledge resources. The platform features a clean architecture with Flutter frontend and Supabase backend, providing real-time updates, secure authentication, and comprehensive feature set for professional networking.',
    'Platform',
    '{"overview", "introduction", "platform"}',
    TRUE
),
(
    'Getting Started with FRINKELS',
    'To get started with FRINKELS, users need to: 1) Download the app from their respective app store, 2) Create an account using email/password or Google Sign-In, 3) Complete the onboarding process to set up their professional profile, 4) Explore the home feed to discover local businesses, communities, and job opportunities, 5) Use the search functionality to find specific content, 6) Connect with other professionals and join communities.',
    'Getting Started',
    '{"tutorial", "beginner", "guide"}',
    TRUE
),
(
    'Feature Categories',
    'FRINKELS organizes its features into several categories: Authentication (user signup/login/social login), Home Feed (main content discovery), Nearby Discovery (location-based professional search), Chat & Messaging (real-time communication), Jobs Marketplace (job postings and applications), Communities (interest-based groups), Local Business (business directory and reviews), Notifications (push and in-app alerts), User Settings (profile management and preferences), AI Kittu Assistant (AI-powered features including greetings, chat, resume builder, etc.).',
    'Features',
    '{"features", "categories", "overview"}',
    TRUE
),
(
    'Documentation Contribution Guidelines',
    'To contribute to the FRINKELS knowledge base: 1) Navigate to the Documentation section in the app, 2) Click the floating action button to add new documentation, 3) Fill in the title, content, category, and tags, 4) Set the publication status as needed, 5) Save the documentation. All contributions are subject to review before being published publicly.',
    'Contribution',
    '{"contribution", "guidelines", "documentation"}',
    TRUE
);