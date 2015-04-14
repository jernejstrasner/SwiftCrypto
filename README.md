# SwiftCrypto
A simple wrapper in Swift around the CommonCrypto framework.

To use, simply copy the file `Crypto.swift` into your project and add `#import <CommonCrypto/CommonCrypto.h>` to your bridging header.

# Usage
## Digest
```swift
let hash = "string".sha512
```

## HMAC
```swift
let hmac = "string".hmac(.SHA512, key: "some key")
```
