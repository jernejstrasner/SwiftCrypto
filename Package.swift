// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "SwiftCrypto",
    products: [
        .library(
            name: "SwiftCrypto",
            targets: ["SwiftCrypto"]
        )
    ],
    targets: [
        .target(
            name: "SwiftCrypto"
        ),
        .testTarget(
            name: "SwiftCryptoTests",
            dependencies: ["SwiftCrypto"]
        )
    ]
)
