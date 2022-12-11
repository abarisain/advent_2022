// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let day = "11"

let package = Package(
    name: "day\(day)",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(
              url: "https://github.com/apple/swift-collections.git",
              .upToNextMajor(from: "1.0.0") // or `.upToNextMajor
            )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(
            name: "day\(day)",
            dependencies: [
                .product(name: "Collections", package: "swift-collections")
            ],
            path: "Sources"),
    ]
)
