// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NavigationManager",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // 라이브러리로 공개할 모듈 선언
        .library(
            name: "NavigationManager",
            targets: ["NavigationManager"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "NavigationManager",
            dependencies: []
        ),
        .testTarget(
            name: "NavigationManagerTests",
            dependencies: ["NavigationManager"]
        ),
    ]
)
