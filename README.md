# DayTask

This is a Flutter project powered by [Supabase](https://supabase.com/). It allows users to manage tasks with full CRUD operations, using secure row-level policies.

---

## 🚀 Project Setup

### 1. Clone the Repo

```bash
git clone https://github.com/WhyC03/DayTask.git
cd your-repo
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Add Supabase Credentials

Create a new file at:

```
lib/app_secrets.dart
```

Add the following content:

```dart
const String supabaseUrl = 'your-supabase-url';
const String supabaseAnonKey = 'your-supabase-anon-key';
```

> 🔐 **Note:** Do not commit this file to version control.

---

## 🧠 Supabase Database Setup

Use the SQL Editor in the Supabase dashboard to execute the following scripts.

---

### 📌 Tasks Table Setup

```sql
-- Create the tasks table
create table if not exists tasks (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  description text,
  is_completed boolean not null default false,
  created_at timestamp with time zone default timezone('utc', now()),
  user_id uuid references auth.users(id) not null
);

-- Enable row-level security
alter table tasks enable row level security;

-- Policy: Allow users to view their own tasks
create policy "Allow select for users on their own tasks"
on tasks
for select
using (auth.uid() = user_id);

-- Policy: Allow users to insert tasks with their own user_id
create policy "Allow insert for users on their own tasks"
on tasks
for insert
with check (auth.uid() = user_id);

-- Policy: Allow users to update their own tasks
create policy "Allow update for users on their own tasks"
on tasks
for update
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

-- Policy: Allow users to delete their own tasks
create policy "Allow delete for users on their own tasks"
on tasks
for delete
using (auth.uid() = user_id);
```

---

### 🙋‍♂️ Profiles Table Setup

```sql
-- Create a table for public profiles
create table profiles (
  id uuid references auth.users not null primary key,
  updated_at timestamp with time zone,
  name text,

  constraint name_length check (char_length(name) >= 3)
);

-- Enable row-level security
alter table profiles enable row level security;

-- Public read access
create policy "Public profiles are viewable by everyone." on profiles
  for select using (true);

-- Insert and update policies for users
create policy "Users can insert their own profile." on profiles
  for insert with check ((select auth.uid()) = id);

create policy "Users can update own profile." on profiles
  for update using ((select auth.uid()) = id);

-- Create trigger to auto-insert profile on sign-up
create function public.handle_new_user()
returns trigger
set search_path = ''
as $$
begin
  insert into public.profiles (id, name)
  values (new.id, new.raw_user_meta_data->>'name');
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
```

---

## ✅ Ready to Go!

Once your Supabase project is configured and the database is set up with the above SQL, you're ready to build and run the app 🎉

---

## 🧑‍💻 Author

Made with ❤️ by [Your Name]