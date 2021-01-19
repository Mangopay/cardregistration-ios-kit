// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "cardregistration-ios-kit",
    products: [
        .library(
            name: "mangopay",
            targets: ["mangopay"]),
    ],
    targets: [
        .target(
            name: "mangopay",
            path: "mangopay"
        ),
    ]
)
