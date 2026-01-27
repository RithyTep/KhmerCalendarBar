// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "KhmerCalendarBar",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "KhmerCalendarBar",
            path: "KhmerCalendarBar",
            exclude: ["Info.plist"],
            resources: [
                .process("Assets.xcassets"),
            ]
        ),
    ]
)
