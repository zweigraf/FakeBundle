// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "FakeBundle",
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", .revision("e0cbee1bd73778c1076c675eaf660e97d09f3b32")),
        // PathKit fork supporting SPM4
        .package(url: "https://github.com/PoissonBallon/PathKit.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "fakebundle",
            dependencies: ["Commander", "PathKit"]),
    ]
)
