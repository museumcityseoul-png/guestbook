-- =========================================================
-- 디지털 방명록 Supabase 스키마
-- Supabase 대시보드 > SQL Editor 에 전체를 붙여넣고 [Run] 하세요.
-- 여러 번 실행해도 오류가 나지 않도록 작성되었습니다.
-- =========================================================

-- 1) 테이블 생성
create table if not exists public.guestbook (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  nickname    text check (nickname is null or char_length(nickname) <= 20),
  message     text check (message is null or char_length(message) <= 200),
  image_data  text check (
                image_data is null
                or (image_data like 'data:image/%' and char_length(image_data) <= 2000000)
              ),
  -- 메시지 또는 그림 중 하나는 반드시 있어야 함
  constraint guestbook_not_empty check (
    coalesce(char_length(trim(message)), 0) > 0 or image_data is not null
  )
);

-- 2) 최신순 조회용 인덱스
create index if not exists guestbook_created_at_idx
  on public.guestbook (created_at desc);

-- 3) 권한 (익명 사용자는 '읽기'와 '쓰기'만 가능, 수정/삭제 불가)
grant select, insert on public.guestbook to anon, authenticated;

-- 4) 행 수준 보안(RLS) 활성화 및 정책
alter table public.guestbook enable row level security;

drop policy if exists "guestbook_public_insert" on public.guestbook;
create policy "guestbook_public_insert"
  on public.guestbook
  for insert
  to anon, authenticated
  with check (true);

drop policy if exists "guestbook_public_select" on public.guestbook;
create policy "guestbook_public_select"
  on public.guestbook
  for select
  to anon, authenticated
  using (true);

-- 5) Realtime(실시간) 대상 테이블로 등록
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime'
      and schemaname = 'public'
      and tablename = 'guestbook'
  ) then
    alter publication supabase_realtime add table public.guestbook;
  end if;
end $$;

-- ---------------------------------------------------------
-- (참고) 운영 중 자주 쓰는 쿼리
-- ---------------------------------------------------------
-- 최근 20건 확인:
--   select id, created_at, nickname, message from public.guestbook order by created_at desc limit 20;
-- 특정 글 삭제 (출력 화면에서도 즉시 사라짐):
--   delete from public.guestbook where id = 123;
-- 전체 초기화 (주의: 복구 불가):
--   truncate table public.guestbook restart identity;
