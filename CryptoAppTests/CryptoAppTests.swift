//
//  CryptoAppTests.swift
//  CryptoAppTests
//
//  Created by Jernej Strasner on 10/14/14.
//  Copyright (c) 2014 Jernej Strasner. All rights reserved.
//

import UIKit
import XCTest
import Foundation

class CryptoAppTests: XCTestCase {

	func testHMAC() {
		let string = "test string"
		let key = "test key"

		XCTAssertEqual(string.hmac(.MD5, key: key), "1772c4c9cea1f65ad562a397b375ae76")
		XCTAssertEqual(string.hmac(.SHA1, key: key), "1cf3356aa06b7a7352b6c2297243c6fcebad08ed")
		XCTAssertEqual(string.hmac(.SHA224, key: key), "1cc53342522ed67aa94519bf25bc3917121747e1365bf803cd4c1ff5")
		XCTAssertEqual(string.hmac(.SHA256, key: key), "6864a9fdc9bc77190c4bc6d1d875a0afe19461907f486f4ba5213a1f15b71cc9")
		XCTAssertEqual(string.hmac(.SHA384, key: key), "b1f88b509b61d62bea22ccc22e252b594b49690b4de0e73b747b0d4001eb64201b2eadee098a217d40a3a67a3dbd1f9e")
		XCTAssertEqual(string.hmac(.SHA512, key: key), "95c32d6bab8dd4942d59a6b7551fb9647226a221f805af7e125d72326888e973043a57cf8326f206e68c8fb214baeb2d35146e8af0f3106a50b7a36091e96e00")
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
        let algorithms: [CryptoAlgorithm] = [.MD5, .SHA1, .SHA224, .SHA256, .SHA384, .SHA512]
        let strings = generateTestStrings(100)
        let key = "test key"
        measureBlock {
            for a in algorithms {
                for s in strings {
                    s.hmac(a, key: key)
                }
            }
        }
    }

    func testDigestPerformance() {
        let algorithms: [CryptoAlgorithm] = [.MD5, .SHA1, .SHA224, .SHA256, .SHA384, .SHA512]
        let strings = generateTestStrings(100)
        measureBlock {
            for a in algorithms {
                for s in strings {
                    s.digest(a)
                }
            }
        }
    }

    func generateTestStrings(count: Int) -> [String] {
        var strings: [String] = []
        for i in 0..<count {
            strings.append(NSUUID().UUIDString)
        }
        return strings
    }

}
