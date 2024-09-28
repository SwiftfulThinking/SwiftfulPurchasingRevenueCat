// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftfulPurchasingRevenueCat",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftfulPurchasingRevenueCat",
            targets: ["SwiftfulPurchasingRevenueCat"]),
    ],
    dependencies: [
        // Here we add the dependency for the SendableDictionary package
        .package(url: "https://github.com/SwiftfulThinking/SwiftfulPurchasing.git", "1.0.0"..<"2.0.0"),
        .package(url: "https://github.com/RevenueCat/purchases-ios.git", "5.4.0"..<"6.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftfulPurchasingRevenueCat",
            dependencies: [
                // Adding SwiftfulLogging as a dependency for this target
                .product(name: "SwiftfulPurchasing", package: "SwiftfulPurchasing"),
                .product(name: "RevenueCat", package: "purchases-ios")
            ]
        ),
        .testTarget(
            name: "SwiftfulPurchasingRevenueCatTests",
            dependencies: ["SwiftfulPurchasingRevenueCat"]
        ),
    ]
)
