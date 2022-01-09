// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PortugalTrains",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "PortugalTrains",
            targets: ["PortugalTrains"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PortugalTrains",
            dependencies: []),
        .testTarget(
            name: "PortugalTrainsTests",
            dependencies: ["PortugalTrains"]),
    ]
)
