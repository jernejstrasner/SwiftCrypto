# SwiftCrypto
A simple wrapper in Swift around the CommonCrypto framework.

[![Build Status](https://travis-ci.org/jernejstrasner/SwiftCrypto.svg?branch=master)](https://travis-ci.org/jernejstrasner/SwiftCrypto)

# Swift Package Manager
```swift
// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "YourProject",
    dependencies: [
        .package(url: "https://github.com/jernejstrasner/SwiftCrypto.git", from: "1.0.1")
    ],
    targets: [
        .target(
            name: "YourTarget",
            dependencies: ["SwiftCrypto"]
        ),
    ]
)
```

# Usage
## Digest
```swift
let hash = "string".sha512
```

## HMAC
```swift
let hmac = "string".digest(.SHA512, key: "some key")
```
