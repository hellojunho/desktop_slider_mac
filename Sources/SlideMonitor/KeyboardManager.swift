import Foundation
import CoreGraphics

enum SpaceDirection {
    case left
    case right
}

class KeyboardManager {
    static let shared = KeyboardManager()

    func switchToSpace(_ direction: SpaceDirection) {
        let keyCode: Int = (direction == .left) ? 0x7B : 0x7C

        let script = """
tell application "System Events"
    key code \(keyCode) using control down
end tell
"""
        // 이벤트 탭 스레드 블로킹 방지 — 백그라운드에서 비동기 실행
        DispatchQueue.global(qos: .userInteractive).async {
            let task = Process()
            task.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
            task.arguments = ["-e", script]

            let pipe = Pipe()
            task.standardError = pipe

            do {
                try task.run()
                task.waitUntilExit()

                let errData = pipe.fileHandleForReading.readDataToEndOfFile()
                if let errStr = String(data: errData, encoding: .utf8), !errStr.isEmpty {
                    AccessibilityUtil.log("osascript 오류: \(errStr.trimmingCharacters(in: .whitespacesAndNewlines))")
                } else {
                    AccessibilityUtil.log("Triggered space switch: \(direction)")
                }
            } catch {
                AccessibilityUtil.log("osascript 실행 실패: \(error)")
            }
        }
    }

    func showMissionControl() {
        // Control + Up arrow (key code 126) = Mission Control
        let script = """
tell application "System Events"
    key code 126 using control down
end tell
"""
        DispatchQueue.global(qos: .userInteractive).async {
            let task = Process()
            task.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
            task.arguments = ["-e", script]
            try? task.run()
            AccessibilityUtil.log("Mission Control 실행됨")
        }
    }
}
