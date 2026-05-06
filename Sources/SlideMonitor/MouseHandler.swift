import Foundation
import CoreGraphics
import AppKit

class MouseHandler {
    static let shared = MouseHandler()

    private var eventTap: CFMachPort?
    private var isStarted = false

    // 연속 전환 방지
    private var lastSwitchTime: Date = .distantPast
    private let switchCooldown: TimeInterval = 0.1

    func start() {
        if isStarted { return }

        let eventMask = (1 << CGEventType.scrollWheel.rawValue)    |
                        (1 << CGEventType.otherMouseDown.rawValue) |
                        (1 << CGEventType.tapDisabledByTimeout.rawValue) |
                        (1 << CGEventType.tapDisabledByUserInput.rawValue)

        guard let eventTap = CGEvent.tapCreate(
            tap: .cghidEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                return MouseHandler.shared.handleEvent(proxy: proxy, type: type, event: event)
            },
            userInfo: nil
        ) else {
            AccessibilityUtil.log("이벤트 탭 생성 실패: accessibility=\(AccessibilityUtil.isTrusted()), inputMonitoring=\(AccessibilityUtil.canListenToEvents())")
            return
        }

        self.eventTap = eventTap
        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        isStarted = true
        AccessibilityUtil.log("마우스 모니터링 시작됨")
    }

    private func handleEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        switch type {
        case .tapDisabledByTimeout, .tapDisabledByUserInput:
            if let eventTap {
                CGEvent.tapEnable(tap: eventTap, enable: true)
            }

        // ── Control + 휠 → 데스크탑 좌/우 전환 ──────────────────────────
        case .scrollWheel:
            let flags = event.flags
            guard flags.contains(.maskControl) else { break }

            let deltaY = event.getDoubleValueField(.scrollWheelEventDeltaAxis1)
            guard deltaY != 0 else { break }

            let now = Date()
            guard now.timeIntervalSince(lastSwitchTime) >= switchCooldown else { break }
            lastSwitchTime = now

            if deltaY > 0 {
                // 휠 아래로 → 왼쪽 데스크탑
                KeyboardManager.shared.switchToSpace(.left)
            } else {
                // 휠 위로 → 오른쪽 데스크탑
                KeyboardManager.shared.switchToSpace(.right)
            }
            return nil

        // ── Control + 미들 클릭(휠 버튼) → Mission Control ───────────────
        case .otherMouseDown:
            let flags = event.flags
            let button = event.getIntegerValueField(.mouseEventButtonNumber)
            // 버튼 2 = 미들 클릭 (휠 버튼)
            guard button == 2, flags.contains(.maskControl) else { break }

            AccessibilityUtil.log("Control + 미들 클릭 → Mission Control 실행")
            KeyboardManager.shared.showMissionControl()
            return nil

        default:
            break
        }

        return Unmanaged.passUnretained(event)
    }
}
