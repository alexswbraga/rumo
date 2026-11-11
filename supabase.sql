-- Rumo · ranking do dia. Cole no SQL Editor do Supabase e clique em Run.
create table if not exists public.ranking (
  id bigint generated always as identity primary key,
  day int not null,
  device uuid not null,
  name text not null check (char_length(name) between 2 and 20),
  guesses int not null check (guesses between 1 and 7),   -- 7 = não acertou
  secs int not null check (secs between 3 and 86400),
  created_at timestamptz not null default now(),
  unique (day, device)                                     -- uma entrada por aparelho por dia
);
alter table public.ranking enable row level security;
grant select, insert on public.ranking to anon;
drop policy if exists "ler ranking" on public.ranking;
create policy "ler ranking" on public.ranking for select to anon using (true);
drop policy if exists "entrar no ranking" on public.ranking;
-- só aceita o destino de hoje (dia 1 = 11/11/2026), com 1 dia de folga para fuso horário
create policy "entrar no ranking" on public.ranking for insert to anon
  with check (day between (current_date - date '2026-11-11') and (current_date - date '2026-11-11') + 2);
