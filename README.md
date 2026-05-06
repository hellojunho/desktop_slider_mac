# SlideMonitor 🖱️↔️🖥️

`Control + 마우스 휠`로 macOS 데스크탑(Spaces)을 빠르게 전환하는 메뉴 바 앱입니다.  
Swift로 작성된 네이티브 앱으로, 가볍고 빠르게 동작합니다.

---

## 🎮 단축키

| 동작                        | 결과                                      |
| --------------------------- | ----------------------------------------- |
| `Control` + 🔽 휠 내리기    | ← 왼쪽 데스크탑으로 전환                  |
| `Control` + 🔼 휠 올리기    | → 오른쪽 데스크탑으로 전환                |
| `Control` + 🖱️ 휠 버튼 클릭 | Mission Control 실행 (전체 데스크탑 보기) |

---

## 🚀 설치 및 실행

### 요구사항

- macOS 13 (Ventura) 이상
- Swift (Xcode Command Line Tools 또는 Xcode)

### 1. 클론

```bash
git clone https://github.com/hellojunho/desktop_slider_mac.git
cd desktop_slider_mac
```

### 2. 빌드

```bash
swift build -c release
```

### 3. 실행

```bash
.build/release/SlideMonitor
```

실행하면 상단 메뉴 바에 마우스 커서 아이콘이 나타납니다.

---

## 🔐 권한 설정 (최초 1회)

마우스 이벤트 감지와 키 이벤트 전송을 위해 두 가지 권한이 필요합니다.

### 접근성 권한

1. 앱 실행 시 권한 요청 팝업이 자동으로 뜹니다.
2. **시스템 설정 → 개인정보 보호 및 보안 → 접근성**에서 **SlideMonitor**를 활성화하세요.

### 자동화 권한 (System Events)

1. 첫 데스크탑 전환 시 _"SlideMonitor이(가) System Events를 제어하도록 허용하시겠습니까?"_ 팝업이 뜹니다.
2. **허용**을 클릭하세요.

> 두 권한 모두 허용해야 정상 동작합니다.

---

## ⚙️ 감도 조절

`Sources/SlideMonitor/MouseHandler.swift`의 `switchCooldown` 값으로 전환 민감도를 조절할 수 있습니다.

```swift
private let switchCooldown: TimeInterval = 0.1  // 낮을수록 빠르게 연속 전환
```

---

## ⚠️ 문제 해결

- **아이콘이 안 보여요**: Dock에는 표시되지 않습니다. 상단 메뉴 바(시계 옆)를 확인하세요.
- **전환이 안 돼요**: 시스템 설정에서 접근성 권한과 자동화(System Events) 권한이 모두 켜져 있는지 확인하세요.
- **권한을 껐다가 다시 켜면** 해결되는 경우가 많습니다.

---

**SlideMonitor**와 함께 더 쾌적한 Mac 멀티태스킹을 즐기세요! 🚀
