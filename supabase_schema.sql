-- ====================================================================
-- EduMunch LMS - Complete Supabase Database Schema & Seed Data
-- ====================================================================
-- Instructions:
-- 1. Open Supabase Dashboard: https://supabase.com/dashboard/project/iuvhyhlvbdzkjcxmopjv/sql/new
-- 2. Paste this entire script into the SQL editor
-- 3. Click "Run" (green button)
-- ====================================================================

-- 1. EXTENSIONS
create extension if not exists "uuid-ossp";

-- 2. USER PROFILES TABLE
create table if not exists public.user_profiles (
    id uuid references auth.users on delete cascade primary key,
    email text unique not null,
    full_name text,
    role text not null check (role in ('student', 'teacher', 'parent', 'admin')),
    phone text,
    avatar_url text,
    created_at timestamptz default timezone('utc'::text, now()) not null,
    updated_at timestamptz default timezone('utc'::text, now()) not null
);

-- Profiles Row Level Security
alter table public.user_profiles enable row level security;

drop policy if exists "Profiles are viewable by authenticated users" on public.user_profiles;
create policy "Profiles are viewable by authenticated users" 
on public.user_profiles for select 
using (true);

drop policy if exists "Users can update their own profile" on public.user_profiles;
create policy "Users can update their own profile" 
on public.user_profiles for update 
using (auth.uid() = id);

drop policy if exists "Allow profile insertion" on public.user_profiles;
create policy "Allow profile insertion" 
on public.user_profiles for insert 
with check (true);

-- Auto-create profile trigger on auth signup
create or replace function public.handle_new_user()
returns trigger as $$
begin
    insert into public.user_profiles (id, email, full_name, role)
    values (
        new.id,
        new.email,
        coalesce(new.raw_user_meta_data->>'full_name', split_part(new.email, '@', 1)),
        coalesce(new.raw_user_meta_data->>'role', 
            case 
                when new.email ilike 'teacher%' then 'teacher'
                when new.email ilike 'parent%' then 'parent'
                else 'student'
            end
        )
    )
    on conflict (id) do update set
        email = excluded.email;
    return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
    after insert on auth.users
    for each row execute procedure public.handle_new_user();

-- 3. COURSES & SUBJECTS TABLE
create table if not exists public.courses (
    id uuid primary key default gen_random_uuid(),
    subject text not null, -- Physics, Chemistry, Maths, Biology
    name text not null, -- Kinematics, Electromagnetism, etc.
    description text,
    status text default 'In Progress' check (status in ('Not Started', 'In Progress', 'Completed')),
    progress numeric default 0.0,
    icon text default '⚡',
    color_hex text default '#8B5CF6',
    instructor_name text,
    video_url text,
    created_at timestamptz default timezone('utc'::text, now()) not null
);

alter table public.courses enable row level security;
create policy "Courses are viewable by all authenticated users" on public.courses for select using (true);
create policy "Teachers can insert/update courses" on public.courses for all using (true);

-- 4. ATTENDANCE TABLE
create table if not exists public.attendance (
    id uuid primary key default gen_random_uuid(),
    student_id uuid references public.user_profiles(id) on delete cascade,
    student_email text,
    subject text not null,
    date date default current_date not null,
    time_slot text default '09:30 AM - 11:00 AM',
    status text not null check (status in ('Attended', 'Missed', 'Upcoming', 'Present', 'Absent', 'Late')),
    marked_by text,
    remarks text,
    created_at timestamptz default timezone('utc'::text, now()) not null
);

alter table public.attendance enable row level security;
create policy "Attendance viewable by authenticated users" on public.attendance for select using (true);
create policy "Attendance manageable by teachers" on public.attendance for all using (true);

-- 5. TIMETABLES TABLE
create table if not exists public.timetables (
    id uuid primary key default gen_random_uuid(),
    day_of_week text not null, -- Monday, Tuesday, etc.
    start_time text not null,
    end_time text not null,
    subject text not null,
    professor text,
    classroom text,
    type text default 'class' check (type in ('class', 'break', 'exam')),
    created_at timestamptz default timezone('utc'::text, now()) not null
);

alter table public.timetables enable row level security;
create policy "Timetable readable by authenticated users" on public.timetables for select using (true);
create policy "Timetable manageable by teachers" on public.timetables for all using (true);

-- 6. NOTIFICATIONS & ALERTS TABLE
create table if not exists public.notifications (
    id uuid primary key default gen_random_uuid(),
    title text not null,
    message text not null,
    description text,
    category text default 'General' check (category in ('General', 'Class', 'Exam', 'Assignment', 'Payment', 'PTM')),
    target_role text default 'all' check (target_role in ('all', 'student', 'teacher', 'parent')),
    is_read boolean default false,
    created_at timestamptz default timezone('utc'::text, now()) not null
);

alter table public.notifications enable row level security;
create policy "Notifications readable by all users" on public.notifications for select using (true);
create policy "Notifications manageable by teachers/admins" on public.notifications for all using (true);

-- 7. ASSIGNMENTS TABLE
create table if not exists public.assignments (
    id uuid primary key default gen_random_uuid(),
    title text not null,
    subject text not null,
    description text,
    due_date timestamptz not null,
    total_marks integer default 100,
    attachment_url text,
    created_by text,
    created_at timestamptz default timezone('utc'::text, now()) not null
);

alter table public.assignments enable row level security;
create policy "Assignments viewable by all" on public.assignments for select using (true);
create policy "Assignments manageable by teachers" on public.assignments for all using (true);

-- 8. ASSIGNMENT SUBMISSIONS TABLE
create table if not exists public.assignment_submissions (
    id uuid primary key default gen_random_uuid(),
    assignment_id uuid references public.assignments(id) on delete cascade not null,
    student_id uuid references public.user_profiles(id) on delete cascade,
    student_email text not null,
    file_url text,
    status text default 'submitted' check (status in ('submitted', 'graded', 'late')),
    marks_obtained numeric,
    feedback text,
    submitted_at timestamptz default timezone('utc'::text, now()) not null
);

alter table public.assignment_submissions enable row level security;
create policy "Submissions viewable by students and teachers" on public.assignment_submissions for select using (true);
create policy "Submissions insertable/updatable by students and teachers" on public.assignment_submissions for all using (true);

-- 9. DOUBTS & DISCUSSIONS TABLE
create table if not exists public.doubts (
    id uuid primary key default gen_random_uuid(),
    student_email text not null,
    subject text not null,
    title text not null,
    question text not null,
    status text default 'open' check (status in ('open', 'in_progress', 'resolved')),
    created_at timestamptz default timezone('utc'::text, now()) not null
);

create table if not exists public.doubt_messages (
    id uuid primary key default gen_random_uuid(),
    doubt_id uuid references public.doubts(id) on delete cascade not null,
    sender_name text not null,
    sender_role text not null check (sender_role in ('student', 'teacher')),
    message text not null,
    created_at timestamptz default timezone('utc'::text, now()) not null
);

alter table public.doubts enable row level security;
alter table public.doubt_messages enable row level security;
create policy "Doubts viewable by all users" on public.doubts for select using (true);
create policy "Doubts manageable by participants" on public.doubts for all using (true);
create policy "Doubt messages viewable by all" on public.doubt_messages for select using (true);
create policy "Doubt messages insertable by all" on public.doubt_messages for insert with check (true);

-- 10. PARENT-CHILD LINKS & GRIEVANCES TABLE
create table if not exists public.parent_students (
    id uuid primary key default gen_random_uuid(),
    parent_email text not null,
    student_email text not null,
    student_name text not null,
    pin text default '1234',
    relationship text default 'Parent',
    created_at timestamptz default timezone('utc'::text, now()) not null
);

alter table public.parent_students enable row level security;
create policy "Parent student mapping readable" on public.parent_students for select using (true);
create policy "Parent student mapping manageable" on public.parent_students for all using (true);

-- ====================================================================
-- SEED INITIAL MOCK/DEMO DATA
-- ====================================================================

-- Seed Courses
insert into public.courses (subject, name, description, status, progress, icon, color_hex, instructor_name) values
('Physics', 'Kinematics', 'Study of motion, acceleration, displacement and velocity vectors.', 'In Progress', 0.65, '⚡', '#8B5CF6', 'Prof. Sharma'),
('Physics', 'Electromagnetism', 'Electric fields, Magnetic induction, Faraday laws.', 'Not Started', 0.0, '⚡', '#8B5CF6', 'Prof. Sharma'),
('Chemistry', 'Organic Chemistry Basics', 'Hydrocarbons, functional groups, isomerism and nomenclature.', 'Completed', 1.0, '🧪', '#7E57C2', 'Dr. Verma'),
('Chemistry', 'Stoichiometry', 'Molar mass, chemical equations, reaction yields.', 'In Progress', 0.45, '🧪', '#7E57C2', 'Dr. Verma'),
('Maths', 'Calculus: Integration & Derivatives', 'Limits, differential calculus and definite integration.', 'In Progress', 0.70, '📊', '#66BB6A', 'Prof. Gupta'),
('Maths', 'Coordinate Geometry', 'Straight lines, circles, parabolas, and ellipses.', 'Not Started', 0.0, '📊', '#66BB6A', 'Prof. Gupta')
on conflict do nothing;

-- Seed Timetable
insert into public.timetables (day_of_week, start_time, end_time, subject, professor, classroom, type) values
('Monday', '09:00 AM', '10:30 AM', 'Physics - Kinematics', 'Prof. Sharma', 'Hall A', 'class'),
('Monday', '10:30 AM', '11:00 AM', 'Morning Tea Break', null, 'Cafeteria', 'break'),
('Monday', '11:00 AM', '12:30 PM', 'Chemistry - Organic', 'Dr. Verma', 'Lab 2', 'class'),
('Monday', '12:30 PM', '01:30 PM', 'Lunch Break', null, 'Cafeteria', 'break'),
('Monday', '01:30 PM', '03:00 PM', 'Maths - Calculus', 'Prof. Gupta', 'Room 104', 'class'),
('Tuesday', '09:00 AM', '10:30 AM', 'Physics - Electromagnetism', 'Prof. Sharma', 'Hall A', 'class'),
('Tuesday', '11:00 AM', '12:30 PM', 'Doubt Clearing Session', 'Prof. Sharma', 'Room 102', 'class'),
('Wednesday', '09:00 AM', '10:30 AM', 'Chemistry - Stoichiometry', 'Dr. Verma', 'Lab 2', 'class')
on conflict do nothing;

-- Seed Notifications
insert into public.notifications (title, message, description, category, target_role) values
('Physics Class Scheduled', 'Your Physics class with Prof. Sharma', 'Physics lecture starts at 09:00 AM tomorrow in Hall A. Please bring your notebooks.', 'Class', 'all'),
('Mathematics Exam Alert', 'Unit Test scheduled this Friday', 'Unit Test covering Calculus and Coordinate Geometry is on Friday at 10:00 AM.', 'Exam', 'student'),
('Assignment 3 Uploaded', 'New assignment for Organic Chemistry', 'Please solve problems 1-15 on page 42 and submit before Sunday midnight.', 'Assignment', 'student'),
('Parent-Teacher Meeting (PTM)', 'Quarterly PTM Scheduled for Saturday', 'Dear Parents, PTM will take place on Saturday from 10:00 AM to 01:00 PM.', 'PTM', 'parent')
on conflict do nothing;

-- Seed Assignments
insert into public.assignments (title, subject, description, due_date, total_marks, created_by) values
('Kinematics Problem Set 1', 'Physics', 'Solve questions 1 through 10 on 2D motion and projectile equations.', now() + interval '5 days', 50, 'Prof. Sharma'),
('Reaction Mechanisms Worksheet', 'Chemistry', 'Draw mechanisms for SN1 and SN2 reactions with energy diagrams.', now() + interval '7 days', 100, 'Dr. Verma'),
('Integration Techniques Assignment', 'Maths', 'Solve substitution and integration by parts problems.', now() + interval '3 days', 50, 'Prof. Gupta')
on conflict do nothing;

-- Seed Attendance
insert into public.attendance (student_email, subject, date, time_slot, status, marked_by) values
('student@demo.edumunch.com', 'Physics', current_date, '09:30 AM - 11:00 AM', 'Attended', 'Prof. Sharma'),
('student@demo.edumunch.com', 'Chemistry', current_date, '11:15 AM - 12:45 PM', 'Attended', 'Dr. Verma'),
('student@demo.edumunch.com', 'Maths', current_date, '02:00 PM - 03:30 PM', 'Upcoming', 'Prof. Gupta')
on conflict do nothing;
