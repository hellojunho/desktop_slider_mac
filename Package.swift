// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SlideMonitor",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "SlideMonitor", targets: ["SlideMonitor"])
    ],
    targets: [
        .executableTarget(
            name: "SlideMonitor",
            path: "Sources/SlideMonitor"
        )
    ]
)
