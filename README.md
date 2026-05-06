# SlideMonitor 🖱️↔️🖥️

`Control + 마우스 휠`로 macOS 데스크탑(Spaces)을 빠르게 전환하는 메뉴 바 앱입니다.

---

## 🎮 단축키

| 동작 | 결과 |
|------|------|
| `Control` + 🔽 휠 내리기 | ← 왼쪽 데스크탑으로 전환 |
| `Control` + 🔼 휠 올리기 | → 오른쪽 데스크탑으로 전환 |
| `Control` + 🖱️ 휠 버튼 클릭 | Mission Control 실행 (전체 데스크탑 보기) |

---

## 🚀 설치 가이드 (처음 시작하는 경우)

### 1단계 — Xcode Command Line Tools 설치

Swift와 git을 사용하려면 Apple 개발 도구가 필요합니다.  
터미널을 열고 아래 명령어를 입력하세요.

> **터미널 여는 법**: `Command + Space` → `터미널` 검색 → Enter

```bash
xcode-select --install
```

팝업이 뜨면 **설치** 버튼을 클릭하고 완료될 때까지 기다립니다. (수 분 소요)

설치가 완료됐는지 확인:

```bash
swift --version
git --version
```

두 명령어 모두 버전 정보가 출력되면 정상입니다.

---

### 2단계 — 프로젝트 클론

원하는 위치에서 아래 명령어를 실행합니다.

```bash
git clone https://github.com/hellojunho/desktop_slider_mac.git
cd desktop_slider_mac
```

---

### 3단계 — 빌드

```bash
swift build -c release
```

`Build complete!` 메시지가 뜨면 성공입니다.

---

### 4단계 — 실행

```bash
.build/release/SlideMonitor
```

실행하면 상단 메뉴 바(시계 근처)에 🖱️ 마우스 아이콘이 나타납니다.

---

### 5단계 — 권한 허용 (최초 1회 필수)

앱이 마우스 이벤트를 감지하고 키 이벤트를 전송하려면 두 가지 권한이 필요합니다.

#### ① 접근성 권한
1. 앱 실행 직후 권한 요청 팝업이 자동으로 뜹니다.
2. **시스템 설정 → 개인정보 보호 및 보안 → 접근성** 으로 이동합니다.
3. 목록에서 **SlideMonitor** 를 찾아 스위치를 **켭니다**.  
   (Touch ID 또는 비밀번호 입력이 필요할 수 있습니다.)

#### ② 자동화 권한 (System Events)
1. 첫 데스크탑 전환 시도 시 아래와 같은 팝업이 뜹니다.
   > *"SlideMonitor이(가) System Events를 제어하도록 허용하시겠습니까?"*
2. **허용** 을 클릭합니다.

> ⚠️ 두 권한 모두 허용해야 정상 동작합니다.

---

## ⚙️ 감도 조절

전환 민감도를 바꾸고 싶다면 `Sources/SlideMonitor/MouseHandler.swift` 의 값을 수정하고 다시 빌드하세요.

```swift
// 낮을수록 빠르게 연속 전환 (기본값: 0.1초)
private let switchCooldown: TimeInterval = 0.1
```

---

## ⚠️ 문제 해결

| 증상 | 해결 방법 |
|------|-----------|
| 메뉴 바 아이콘이 안 보임 | Dock에는 표시되지 않습니다. 상단 메뉴 바(시계 옆)를 확인하세요. |
| 전환이 안 됨 | 접근성 권한 + 자동화(System Events) 권한이 모두 켜져 있는지 확인하세요. |
| 권한 설정 후에도 안 됨 | 권한을 껐다가 다시 켜거나, 앱을 재시작해 보세요. |

---

**SlideMonitor**와 함께 더 쾌적한 Mac 멀티태스킹을 즐기세요! 🚀
