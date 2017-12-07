// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "SwiftCrypto",
    products: [
        .library(
            name: "SwiftCrypto",
            targets: ["SwiftCrypto"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/jernejstrasner/CCommonCrypto.git", .branch("master"))
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
