// The MIT License (MIT)
//
// Copyright (c) 2018 Jernej Strasner
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import XCTest
import SwiftCrypto

class SwiftCryptoTests: XCTestCase {
    
    func testHMAC() {
        let string = "test string"
        let key = "test key"

        XCTAssertEqual(string.digest(.md5, key: key), "1772c4c9cea1f65ad562a397b375ae76")
        XCTAssertEqual(string.digest(.sha1, key: key), "1cf3356aa06b7a7352b6c2297243c6fcebad08ed")
        XCTAssertEqual(string.digest(.sha224, key: key), "1cc53342522ed67aa94519bf25bc3917121747e1365bf803cd4c1ff5")
        XCTAssertEqual(string.digest(.sha256, key: key), "6864a9fdc9bc77190c4bc6d1d875a0afe19461907f486f4ba5213a1f15b71cc9")
        XCTAssertEqual(string.digest(.sha384, key: key), "b1f88b509b61d62bea22ccc22e252b594b49690b4de0e73b747b0d4001eb64201b2eadee098a217d40a3a67a3dbd1f9e")
        XCTAssertEqual(string.digest(.sha512, key: key), "95c32d6bab8dd4942d59a6b7551fb9647226a221f805af7e125d72326888e973043a57cf8326f206e68c8fb214baeb2d35146e8af0f3106a50b7a36091e96e00")
    }

    func testDigest() {
        let string = "test string"

        XCTAssertEqual(string.md5, "6f8db599de986fab7a21625b7916589c")
        XCTAssertEqual(string.sha1, "661295c9cbf9d6b2f6428414504a8deed3020641")
        XCTAssertEqual(string.sha224, "dd8a1f5793f157323ccb28fe953bb8abb659bd61b7e9fae10be26f7a")
        XCTAssertEqual(string.sha256, "d5579c46dfcc7f18207013e65b44e4cb4e2c2298f4ac457ba8f82743f31e930b")
        XCTAssertEqual(string.sha384, "e213dccb3221e0b8fdd995dcc1d04e218fc649981038bfac81abc98932369bac0efb758b92eccd80321df8eb64efae87")
        XCTAssertEqual(string.sha512, "10e6d647af44624442f388c2c14a787ff8b17e6165b83d767ec047768d8cbcb71a1a3226e7cc7816bc79c0427d94a9da688c41a3992c7bf5e4d7cc3e0be5dbac")
    }

    func testHMACPerformance() {
        let algorithms: [SwiftCrypto.Algorithm] = [.md5, .sha1, .sha224, .sha256, .sha384, .sha512]
        let strings = generateTestStrings(100)
        let key = "test key"
        measure {
            for a in algorithms {
                for s in strings {
                    _ = s.digest(a, key: key)
                }
            }
        }
    }

    func testDigestPerformance() {
        let algorithms: [SwiftCrypto.Algorithm] = [.md5, .sha1, .sha224, .sha256, .sha384, .sha512]
        let strings = generateTestStrings(100)
        measure {
            for a in algorithms {
                for s in strings {
                    _ = s.digest(a)
                }
            }
        }
    }

    func generateTestStrings(_ count: Int) -> [String] {
        var strings = [String]()
        for _ in 0..<count {
            strings.append(UUID().uuidString)
        }
        return strings
    }

}
