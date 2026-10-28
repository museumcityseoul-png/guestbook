# 우리소리 방명록 설치 가이드

작성 패드(`input.html`, 태블릿)에서 작성한 메시지·그림이 Supabase를 거쳐 디지털 월(`display.html`, 전자칠판)에 실시간으로 나타나는 웹 애플리케이션입니다.

## 0. 파일 구성

```
guestbook/
├── config.js      ← Supabase URL·키 입력 (이 파일만 수정)
├── input.html     ← 작성 패드 (태블릿)
├── display.html   ← 디지털 월 (전자칠판)
├── logo_wall.png  ← 디지털 월 우측 하단 로고 (어두운 배경용 색 변환본)
├── logo.png       ← 로고 원본
├── fonts/         ← 서울한강체 (디지털 월용, .woff 4종: L·M·B·EB)
├── schema.sql     ← DB 테이블 생성 SQL
└── README.md      ← 이 문서
```

모든 파일은 반드시 **같은 폴더**에 두어야 합니다.

---

## 1단계. Supabase 프로젝트 만들기

1. https://supabase.com 에 접속해 회원가입(GitHub 계정 또는 이메일)합니다.
2. **New project** 를 누릅니다.
3. 프로젝트 이름(예: `guestbook`), 데이터베이스 비밀번호, 지역(Region)을 입력합니다.
   - 지역은 전시장과 가까운 곳(예: Seoul 또는 Tokyo)을 선택하면 지연이 줄어듭니다.
4. **Create new project** 를 누르고 생성이 끝날 때까지(1~2분) 기다립니다.

## 2단계. 테이블 만들기 (SQL 실행)

1. 왼쪽 메뉴에서 **SQL Editor** 를 엽니다.
2. **New query** 를 누르고 `schema.sql` 내용 전체를 붙여넣습니다.
3. 오른쪽 아래 **Run** 을 누릅니다. `Success` 가 표시되면 완료입니다.
4. 왼쪽 메뉴 **Table Editor** 에서 `guestbook` 테이블이 생겼는지 확인합니다.

이 SQL은 다음을 한 번에 처리합니다.
- `guestbook` 테이블 생성 (`id`, `created_at`, `nickname`, `message`, `image_data`)
- 익명 사용자에게 읽기·쓰기만 허용(RLS 정책), 수정·삭제는 차단
- Realtime(실시간) 대상 테이블 등록

## 3단계. URL과 키를 `config.js`에 입력

1. 왼쪽 아래 **Project Settings**(톱니바퀴) → **API** 또는 **API Keys** 메뉴로 이동합니다.
   (대시보드 화면 구성은 Supabase 업데이트에 따라 달라질 수 있습니다.)
2. 아래 두 값을 복사합니다.
   - **Project URL** : `https://xxxxxxxx.supabase.co` 형태
   - **anon public 키** 또는 **publishable 키**
3. `config.js` 를 메모장(또는 VS Code)으로 열어 아래처럼 바꾸고 저장합니다.

```js
SUPABASE_URL: 'https://xxxxxxxx.supabase.co',
SUPABASE_ANON_KEY: '복사한 키 전체',
```

> ⚠️ **service_role 키(또는 secret 키)는 절대 넣지 마세요.** 이 키는 모든 권한을 가지므로 웹페이지에 노출되면 안 됩니다.

## 4단계. 내 PC에서 먼저 테스트하기

### 방법 A — Python 사용 (설치되어 있는 경우)
1. 파일이 있는 폴더에서 터미널(명령 프롬프트)을 엽니다.
2. 다음을 실행합니다.
   ```
   python -m http.server 8000
   ```
3. 브라우저에서 두 창을 엽니다.
   - 입력: `http://localhost:8000/input.html`
   - 출력: `http://localhost:8000/display.html`
4. 입력 창에서 글을 남기면 출력 창에 바로 나타나는지 확인합니다.

### 방법 B — VS Code 사용
1. VS Code에서 폴더를 열고 확장 프로그램 **Live Server** 를 설치합니다.
2. `input.html` 에서 마우스 오른쪽 → **Open with Live Server**.

### 같은 Wi-Fi의 태블릿에서 테스트
- PC의 내부 IP(예: `192.168.0.10`)를 확인한 뒤, 태블릿에서 `http://192.168.0.10:8000/input.html` 로 접속합니다.
- 접속되지 않으면 PC 방화벽에서 해당 포트를 허용해야 할 수 있습니다.

## 5단계. 인터넷에 올리기 (실제 전시용 권장)

태블릿과 전자칠판이 PC 없이도 접속하려면 정적 호스팅에 올립니다. 아래는 예시이며, 어느 하나만 하면 됩니다.

**Netlify Drop (가장 간단)**
1. https://app.netlify.com/drop 에 접속(로그인 필요할 수 있음)합니다.
2. 파일이 든 폴더를 화면에 끌어다 놓습니다.
3. 발급된 주소(`https://○○○.netlify.app`)로 접속합니다.
   - 입력: `https://○○○.netlify.app/input.html`
   - 출력: `https://○○○.netlify.app/display.html`

**GitHub Pages**
1. GitHub 저장소를 만들고 파일을 업로드합니다.
2. 저장소 **Settings → Pages** 에서 배포 브랜치를 지정합니다.

HTTPS 주소로 올리면 출력 화면의 "화면 꺼짐 방지" 기능도 동작합니다(지원 브라우저 한정).

## 6단계. 태블릿 설정

1. 태블릿 브라우저로 `input.html` 주소에 접속합니다.
2. **홈 화면에 추가**하면 주소창 없이 앱처럼 열립니다.
   - iPad(Safari): 공유 버튼 → 홈 화면에 추가
   - Android(Chrome): 메뉴(⋮) → 홈 화면에 추가
3. 관람객이 다른 앱으로 나가지 못하게 하려면 기기 기능을 사용합니다.
   - iPad: 설정 → 손쉬운 사용 → **사용법 유도된 접근(Guided Access)**
   - Android: 설정 → 보안 → **앱 고정(화면 고정)**
4. 자동 잠금(화면 꺼짐) 시간을 '안 함' 또는 길게 설정합니다.

## 7단계. 전자칠판(미디어월) 설정

1. 전자칠판 브라우저로 `display.html` 주소에 접속합니다.
2. 화면 오른쪽 아래 **전체화면** 버튼을 누르거나 키보드 **F** 키를 누릅니다.
3. 마우스를 3초간 움직이지 않으면 커서와 버튼이 자동으로 숨겨집니다.
4. Windows PC 연결 시 Chrome 키오스크 모드로 바로 실행할 수도 있습니다.
   ```
   chrome.exe --kiosk https://○○○.netlify.app/display.html
   ```
5. 화면 왼쪽 아래 점의 색으로 연결 상태를 확인할 수 있습니다.
   - 초록: 실시간 연결됨 / 노랑: 연결 중 / 빨강: 오류(5초마다 자동 재연결)

해상도는 1920×1080 기준으로 설계되어 화면 크기에 맞춰 자동 확대·축소됩니다(4K 3840×2160 포함). 16:9가 아닌 화면에서는 위아래 또는 좌우에 검은 여백이 생깁니다.

## 8단계. 운영 방법

| 작업 | 방법 |
|---|---|
| 부적절한 글 삭제 | Supabase **Table Editor → guestbook** 에서 해당 행 선택 → Delete. 출력 화면에서도 즉시 사라집니다. |
| 비속어 단어 추가 | `input.html` 의 `BAD_WORDS` 배열에 단어 추가 후 저장(배포했다면 다시 업로드) |
| 정상 단어 오탐 해제 | `input.html` 의 `ALLOW_WORDS` 배열에 단어 추가 |
| 디지털 월 최대 카드 수 변경 | `config.js` 의 `WALL_MAX_CARDS` 값 수정 (기본 40) |
| 디지털 월 제목·부제 변경 | `config.js` 의 `WALL_TITLE`, `WALL_SUBTITLE` 수정 |
| 작성 패드 제목·버튼 문구 변경 | `config.js` 의 `PAD_TITLE`, `PAD_BUTTON` 수정 |
| 디지털 월 포인트 색 변경 | `config.js` 의 `WALL_ACCENT` 값을 색상 코드로 수정 (예: `'#1f5f8b'`) |
| 로고 교체 | `logo_wall.png` 파일을 같은 이름으로 교체 (투명 배경 PNG, 밝은 색 권장) |
| 카드 정렬 | 디지털 월 좌측 하단 **정렬** 버튼 터치 또는 키보드 **S** |
| 전체 초기화 | SQL Editor에서 `truncate table public.guestbook restart identity;` 실행(복구 불가) |

## 동작 사양 요약

**작성 패드**
- 성함 또는 닉네임(선택, 20자), 남기실 말씀(200자)
- 펜 색상 4가지, 그림 지우기, X 버튼으로 작성 내용 전체 초기화(확인 팝업)
- 비속어 포함 시 "부적절한 단어가 포함되어 있습니다." 팝업 후 제출 차단
- 메시지와 그림이 모두 비어 있으면 제출 차단
- 그림은 가로 최대 800px로 줄여 WebP(미지원 기기는 JPEG) Base64로 전송
- 전송 성공 시 "감사합니다" 모달(3.5초 후 자동 닫힘) + 입력 초기화

**디지털 월**
- 시작 시 최근 40건을 불러와 화면에 배치
- 새 글은 화면 중앙에서 확대되며 등장 → 약 3초 체류 → 빈 자리로 이동 → 부유
- 40개 초과 시 가장 오래된 카드부터 페이드아웃되어 화면에서 숨겨짐 (DB 데이터는 삭제되지 않음)
- **정렬** 버튼: 카드가 오래된 순(좌상단 → 우하단) 격자로 모여 5초간 정렬 상태 유지 후 다시 부유
- 카드 우측 하단에 작성일(yyyy-mm-dd) 표시
- 연결이 끊겼다가 복구되면 그 사이 들어온 글을 자동으로 보충

## 문제 해결

| 증상 | 확인할 점 |
|---|---|
| 상단에 "config.js에 … 설정되지 않았습니다" 표시 | `config.js` 의 URL·키가 `YOUR-` 로 남아 있지 않은지 확인 |
| 제출 시 "전송 실패" | ① `schema.sql` 실행 여부 ② 키 오타 ③ 브라우저 개발자도구(F12) Console의 오류 메시지 확인 |
| 제출은 되는데 출력 화면에 안 나타남 | `schema.sql` 5)번(Realtime 등록)이 실행됐는지 확인. Supabase **Database → Publications → supabase_realtime** 에서 `guestbook` 포함 여부 확인 |
| 출력 화면이 새로고침해야만 갱신됨 | 왼쪽 아래 상태 점이 빨간색인지 확인. 네트워크(방화벽)에서 WebSocket 차단 여부 확인 |
| 한동안 사용하지 않았더니 동작 안 함 | Supabase 무료 플랜 프로젝트는 일정 기간 활동이 없으면 일시 정지될 수 있습니다. 대시보드에서 프로젝트를 다시 활성화(Restore)하세요. |
| 글꼴이 다르게 보임 | 인터넷이 연결되지 않으면 Google Fonts 대신 기기 기본 글꼴로 표시됩니다. |
