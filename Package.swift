// swift-tools-version: 6.4

import PackageDescription

extension String {
    static let foundationDateExtensions: Self = "Foundation Date Extensions"
    static let foundationExtensions: Self = "Foundation Extensions"
}

extension Target.Dependency {
    static var foundationExtensions: Self { .target(name: .foundationExtensions) }
    static var foundationDateExtensions: Self { .target(name: .foundationDateExtensions) }
}

let package = Package(
    name: "swift-foundation-extensions",
    platforms: [
        .iOS(.v27),
        .macOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
    ],
    products: [
        .library(name: .foundationDateExtensions, targets: [.foundationDateExtensions]),
        .library(name: .foundationExtensions, targets: [.foundationExtensions]),
    ],
    targets: [
        .target(
            name: .foundationExtensions,
            dependencies: [
                .foundationDateExtensions
            ]
        ),
        .testTarget(
            name: .foundationExtensions.tests,
            dependencies: [
                .foundationExtensions
            ]
        ),
        .target(
            name: .foundationDateExtensions
        ),
        .testTarget(
            name: .foundationDateExtensions.tests,
            dependencies: [
                .foundationDateExtensions,
                .foundationExtensions,
            ]
        ),
    ]
)

extension String { var tests: Self { self + " Tests" } }
