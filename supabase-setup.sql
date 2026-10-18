-- Fresh project: run once. Never place a service-role key in frontend files.
create table public.admin_users(user_id uuid primary key references auth.users(id) on delete cascade);
alter table public.admin_users enable row level security;
create function public.is_admin() returns boolean language sql stable security definer set search_path=public as $$ select exists(select 1 from public.admin_users where user_id=auth.uid()) $$;
revoke all on function public.is_admin() from public;
grant execute on function public.is_admin() to anon,authenticated;
create table public.waitlist(id uuid primary key default gen_random_uuid(),full_name text not null,email text unique not null,phone text not null,target_exam text not null,status text not null default 'pending' check(status in('pending','approved','rejected')),created_at timestamptz not null default now());
alter table public.waitlist enable row level security;
create policy "Admin waitlist" on public.waitlist for all to authenticated using(public.is_admin()) with check(public.is_admin());
create function public.join_waitlist(p_name text,p_email text,p_phone text,p_exam text) returns void language plpgsql security definer set search_path=public as $$ begin
if length(trim(p_name))<2 or length(p_name)>100 or length(p_email)>254 or p_email !~ '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$' or p_phone !~ '^[+0-9 ()-]{8,20}$' or length(trim(p_exam))=0 or length(p_exam)>100 then raise exception 'Enter valid registration details.'; end if;
perform pg_advisory_xact_lock(99919026);
if(select count(*) from public.waitlist where status='approved')>=999 then raise exception 'All founding places have been confirmed.'; end if;
insert into public.waitlist(full_name,email,phone,target_exam) values(trim(p_name),lower(trim(p_email)),trim(p_phone),trim(p_exam));
exception when unique_violation then raise exception 'This email is already registered.'; end $$;
revoke all on function public.join_waitlist(text,text,text,text) from public;
grant execute on function public.join_waitlist(text,text,text,text) to anon,authenticated;
create function public.cap_members() returns trigger language plpgsql security definer set search_path=public as $$ begin
if new.status='approved' then perform pg_advisory_xact_lock(99919026); if(select count(*) from public.waitlist where status='approved' and id<>new.id)>=999 then raise exception '999-member approval limit reached.'; end if; end if; return new; end $$;
create trigger member_cap before insert or update of status on public.waitlist for each row execute function public.cap_members();
create table public.resources(id uuid primary key default gen_random_uuid(),title text not null,category text not null,description text not null,file_path text not null,published boolean not null default false,created_at timestamptz not null default now());
create table public.notifications(id uuid primary key default gen_random_uuid(),title text not null,category text not null,description text not null,official_url text,deadline date,published boolean not null default false,created_at timestamptz not null default now());
alter table public.resources enable row level security;
alter table public.notifications enable row level security;
create policy "Read published resources" on public.resources for select to anon,authenticated using(published or public.is_admin());
create policy "Admin resources" on public.resources for all to authenticated using(public.is_admin()) with check(public.is_admin());
create policy "Read published notifications" on public.notifications for select to anon,authenticated using(published or public.is_admin());
create policy "Admin notifications" on public.notifications for all to authenticated using(public.is_admin()) with check(public.is_admin());
grant usage on schema public to anon,authenticated;
revoke all on public.admin_users from anon,authenticated;
revoke all on public.waitlist from anon;
grant select,insert,update,delete on public.waitlist,public.resources,public.notifications to authenticated;
grant select on public.resources,public.notifications to anon;
insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values('learning-files','learning-files',true,20971520,array['application/pdf','text/html']) on conflict(id) do nothing;
create policy "Admin upload" on storage.objects for insert to authenticated with check(bucket_id='learning-files' and public.is_admin());
create policy "Admin file read" on storage.objects for select to authenticated using(bucket_id='learning-files' and public.is_admin());
create policy "Admin file update" on storage.objects for update to authenticated using(bucket_id='learning-files' and public.is_admin()) with check(bucket_id='learning-files' and public.is_admin());
create policy "Admin file delete" on storage.objects for delete to authenticated using(bucket_id='learning-files' and public.is_admin());
-- After creating your user in Authentication > Users, run separately:
-- insert into public.admin_users(user_id) values ('YOUR_USER_UUID');
