-- ENTRENA SUB9 v3: tabla privada por usuario.
-- Ejecuta este archivo en Supabase -> SQL Editor -> New query -> Run.
-- Guarda un registro separado por mesociclo, sesión, Polar, báscula y ajustes.
-- SOLO el usuario autenticado puede consultar o cambiar SUS registros.

create table if not exists public.entrena_items (
  user_id uuid not null references auth.users(id) on delete cascade,
  kind text not null check (kind in ('mesocycles','workouts','polar','body','settings')),
  item_id text not null,
  payload jsonb not null default '{}'::jsonb,
  deleted boolean not null default false,
  updated_at timestamptz not null default now(),
  primary key (user_id, kind, item_id)
);

-- Actualiza la revisión en el servidor cuando cambia un registro.
create or replace function public.entrena_touch_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = pg_catalog.now();
  return new;
end;
$$;

drop trigger if exists entrena_touch_updated_at on public.entrena_items;
create trigger entrena_touch_updated_at
before update on public.entrena_items
for each row execute function public.entrena_touch_updated_at();

alter table public.entrena_items enable row level security;

-- En lugar de dejar filas públicas, se exige una sesión válida de Supabase Auth.
drop policy if exists "entrena_sel_own" on public.entrena_items;
create policy "entrena_sel_own"
on public.entrena_items for select to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "entrena_ins_own" on public.entrena_items;
create policy "entrena_ins_own"
on public.entrena_items for insert to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "entrena_upd_own" on public.entrena_items;
create policy "entrena_upd_own"
on public.entrena_items for update to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

drop policy if exists "entrena_del_own" on public.entrena_items;
create policy "entrena_del_own"
on public.entrena_items for delete to authenticated
using ((select auth.uid()) = user_id);

grant select, insert, update, delete on public.entrena_items to authenticated;
revoke all on public.entrena_items from anon;

create index if not exists entrena_items_updated_idx
on public.entrena_items (user_id, updated_at desc);
