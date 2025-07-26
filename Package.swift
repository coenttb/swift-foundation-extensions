// swift-tools-version:5.10.1

import PackageDescription

extension String {
    static let dateExtensions: Self = "DateExtensions"
}

extension Target.Dependency {
    static var dateExtensions: Self { .target(name: .dateExtensions) }
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
    static var dependenciesTestSupport: Self { .product(name: "DependenciesTestSupport", package: "swift-dependencies") }
}

let package = Package(
    name: "swift-foundation-extensions",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        .library(name: .dateExtensions, targets: [.dateExtensions]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.3.5"),
    ],
    targets: [
        .target(
            name: .dateExtensions,
            dependencies: [
                .dependencies
            ]
        ),
        .testTarget(
            name: .dateExtensions.tests,
            dependencies: [
                .dateExtensions,
                .dependenciesTestSupport
            ]
        ),
    ]
)

extension String { var tests: Self { self + " Tests" } }
