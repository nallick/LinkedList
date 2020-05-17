// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "LinkedList",
    platforms: [.iOS(.v10), .macOS(.v10_12)],
    products: [
        .library(
            name: "LinkedList",
            targets: ["LinkedList"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nallick/BaseSwift.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "LinkedList",
            dependencies: ["BaseSwift"]),
        .testTarget(
            name: "LinkedListTests",
            dependencies: ["BaseSwift", "LinkedList"]),
    ]
)
