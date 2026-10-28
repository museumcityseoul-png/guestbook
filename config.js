/* =========================================================
 * 우리소리 방명록 공용 설정 파일
 * 작성 패드(input.html) / 디지털 월(display.html)이 모두 이 파일을 읽습니다.
 * 아래 두 값만 본인 Supabase 프로젝트 값으로 바꾸면 됩니다.
 * ========================================================= */
window.GUESTBOOK_CONFIG = {
  // Supabase 프로젝트 URL (예: https://abcdefghijkl.supabase.co)
  SUPABASE_URL: 'https://uazfkrsjsqovhkfdzwxn.supabase.co/rest/v1/',

  // Supabase 익명 키 (anon key 또는 publishable key)
  SUPABASE_ANON_KEY: 'sb_publishable_rKlbKmJ8GNhIb3naym6KSw_zHURFCXJ',

  // 테이블 이름 (SQL과 동일해야 함)
  TABLE: 'guestbook',

  // ---- 디지털 월 ----
  WALL_TITLE: '우리소리 방명록',
  WALL_SUBTITLE: '개관 7주년 축하 메시지를 남겨주세요.',
  WALL_MAX_CARDS: 40,          // 화면에 동시에 띄우는 최대 개수 (초과분은 화면에서만 숨김)
  WALL_ACCENT: '#c0392b',      // 포인트 색 (카드 상단 띠, 제목 밑줄, 정렬 버튼)

  // ---- 작성 패드 ----
  PAD_TITLE: '방명록 작성하기',
  PAD_BUTTON: '미디어 월에 남기기'
};
