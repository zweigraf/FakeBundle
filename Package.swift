// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "FakeBundle",
    products: [
        .executable(name: "fakebundle", targets: ["fakebundle"])
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", from: "0.8.0"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "fakebundle",
            dependencies: ["Commander", "PathKit"]),
    ]
)
