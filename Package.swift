// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-foundation-extensions",
    platforms: [
        .iOS(.v27),
        .macOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
    ],
    products: [
        .library(name: "Foundation Date Extensions", targets: ["Foundation Date Extensions"]),
        .library(name: "Foundation Extensions", targets: ["Foundation Extensions"]),
    ],
    targets: [
        .target(
            name: "Foundation Extensions",
            dependencies: [
                .target(name: "Foundation Date Extensions")
            ]
        ),
        .testTarget(
            name: "Foundation Extensions Tests",
            dependencies: [
                .target(name: "Foundation Extensions")
            ]
        ),
        .target(
            name: "Foundation Date Extensions"
        ),
        .testTarget(
            name: "Foundation Date Extensions Tests",
            dependencies: [
                .target(name: "Foundation Date Extensions"),
                .target(name: "Foundation Extensions"),
            ]
        ),
    ]
)

