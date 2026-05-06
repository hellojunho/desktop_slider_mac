import Foundation
import ApplicationServices
import AppKit

struct AccessibilityUtil {
    static func isTrusted() -> Bool {
        return AXIsProcessTrusted()
    }

    static func canListenToEvents() -> Bool {
        return CGPreflightListenEventAccess()
    }
    
    static func requestAccessibility() {
        let options: [String: Any] = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        AXIsProcessTrustedWithOptions(options as CFDictionary)
        CGRequestListenEventAccess()
    }
    
    static func openSystemSettings() {
        let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(url)
    }

    static func log(_ message: String) {
        let line = "[\(Date())] \(message)\n"
        let url = URL(fileURLWithPath: "/tmp/SlideMonitor.log")

        if FileManager.default.fileExists(atPath: url.path),
           let fileHandle = try? FileHandle(forWritingTo: url) {
            fileHandle.seekToEndOfFile()
            fileHandle.write(Data(line.utf8))
            try? fileHandle.close()
        } else {
            try? line.write(to: url, atomically: true, encoding: .utf8)
        }
    }
}
