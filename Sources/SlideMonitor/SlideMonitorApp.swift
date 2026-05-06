import SwiftUI

@main
struct SlideMonitorApp: App {
    @State private var isPermissionGranted = AccessibilityUtil.isTrusted()
    
    // 권한 확인을 위한 타이머 (권한이 없을 때만 동작)
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    init() {
        AccessibilityUtil.log("앱 시작됨, accessibility=\(AccessibilityUtil.isTrusted()), inputMonitoring=\(AccessibilityUtil.canListenToEvents())")
        if AccessibilityUtil.isTrusted() {
            MouseHandler.shared.start()
        } else {
            AccessibilityUtil.requestAccessibility()
        }
    }
    
    var body: some Scene {
        MenuBarExtra {
            // 메뉴 바 내용
            MenuContent(isPermissionGranted: $isPermissionGranted)
        } label: {
            Image(systemName: "cursorarrow")
                .foregroundColor(isPermissionGranted ? .primary : .red)
                .onReceive(timer) { _ in
                    let isTrusted = AccessibilityUtil.isTrusted()
                    let canListen = AccessibilityUtil.canListenToEvents()
                    if isPermissionGranted != isTrusted {
                        AccessibilityUtil.log("접근성 상태 변경: accessibility=\(isTrusted), inputMonitoring=\(canListen)")
                        isPermissionGranted = isTrusted
                    }
                    if isTrusted {
                        MouseHandler.shared.start()
                    }
                }
        }
    }
}

struct MenuContent: View {
    @Binding var isPermissionGranted: Bool
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if !isPermissionGranted {
                Text("접근성/입력 모니터링 권한이 필요합니다")
                    .font(.caption)
                Button("권한 요청 및 설정 열기") {
                    AccessibilityUtil.requestAccessibility()
                    AccessibilityUtil.openSystemSettings()
                }
                Divider()
            } else {
                Text("상태: 동작 중")
                Divider()
            }
            
            Button("설정 열기...") {
                AccessibilityUtil.openSystemSettings()
            }
            
            Divider()
            
            Button("종료") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}
