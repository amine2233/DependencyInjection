// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let swiftSettings: [PackageDescription.SwiftSetting] = [
    .unsafeFlags(["-require-explicit-sendable"]),
    .enableUpcomingFeature("ExistentialAny"),
    .enableExperimentalFeature("SuppressedAssociatedTypes"),
    .enableExperimentalFeature("StrictConcurrency")
    // .enableExperimentalFeature("AccessLevelOnImport"),
    // .enableUpcomingFeature("InternalImportsByDefault"),
]

let package = Package(
    name: "DependencyInjection",
    platforms: [.iOS(.v13), .macOS(.v10_15), .watchOS(.v6), .tvOS(.v13), .visionOS(.v1)],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DependencyInjection",
            targets: ["DependencyInjection"]
        ),
        .library(
            name: "DependencyInjectionProperty",
            targets: ["DependencyInjectionProperty"]
        ),
        .library(
            name: "DependencyInjectionPropertyWrapper",
            targets: ["DependencyInjectionPropertyWrapper"]
        ),
        .library(
            name: "DependencyInjectionAutoRegistration",
            targets: ["DependencyInjectionAutoRegistration"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DependencyInjection",
            dependencies: [],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "DependencyInjectionPropertyWrapper",
            dependencies: ["DependencyInjection"],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "DependencyInjectionAutoRegistration",
            dependencies: ["DependencyInjection"],
            swiftSettings: swiftSettings
        ),
        .target(
            name: "DependencyInjectionProperty",
            dependencies: ["DependencyInjection"]
        ),
        .testTarget(
            name: "DependencyInjectionTests",
            dependencies: ["DependencyInjection"],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "DependencyInjectionPropertyWrapperTests",
            dependencies: ["DependencyInjectionPropertyWrapper"],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "DependencyInjectionAutoRegistrationTests",
            dependencies: ["DependencyInjectionAutoRegistration"],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "DependencyInjectionPropertyTests",
            dependencies: ["DependencyInjectionProperty"],
            swiftSettings: swiftSettings
        )
    ],
    swiftLanguageModes: [.v6, .v5]
)
