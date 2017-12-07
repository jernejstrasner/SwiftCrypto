// The MIT License (MIT)
//
// Copyright (c) 2015 Jernej Strasner
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
import CCommonCrypto

public enum CryptoAlgorithm {
    case md5, sha1, sha224, sha256, sha384, sha512

    fileprivate var hmacAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .md5:		result = kCCHmacAlgMD5
        case .sha1:		result = kCCHmacAlgSHA1
        case .sha224:	result = kCCHmacAlgSHA224
        case .sha256:	result = kCCHmacAlgSHA256
        case .sha384:	result = kCCHmacAlgSHA384
        case .sha512:	result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }

    fileprivate typealias DigestAlgorithm = (UnsafeRawPointer, CC_LONG, UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8>!

    fileprivate var digestAlgorithm: DigestAlgorithm {
        switch self {
        case .md5:      return CC_MD5
        case .sha1:     return CC_SHA1
        case .sha224:   return CC_SHA224
        case .sha256:   return CC_SHA256
        case .sha384:   return CC_SHA384
        case .sha512:   return CC_SHA512
        }
    }

    public var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .md5:		result = CC_MD5_DIGEST_LENGTH
        case .sha1:		result = CC_SHA1_DIGEST_LENGTH
        case .sha224:	result = CC_SHA224_DIGEST_LENGTH
        case .sha256:	result = CC_SHA256_DIGEST_LENGTH
        case .sha384:	result = CC_SHA384_DIGEST_LENGTH
        case .sha512:	result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

public protocol Hashing {
    associatedtype T
    func digest(_ algorithm: CryptoAlgorithm, key: String?) -> T

    var md5: T { get }
    var sha1: T { get }
    var sha224: T { get }
    var sha256: T { get }
    var sha384: T { get }
    var sha512: T { get }
}

extension Hashing {

    public var md5: T {
        return digest(.md5, key: nil)
    }

    public var sha1: T {
        return digest(.sha1, key: nil)
    }

    public var sha224: T {
        return digest(.sha224, key: nil)
    }

    public var sha256: T {
        return digest(.sha256, key: nil)
    }

    public var sha384: T {
        return digest(.sha384, key: nil)
    }

    public var sha512: T {
        return digest(.sha512, key: nil)
    }

}

extension String : Hashing {

    public func digest(_ algorithm: CryptoAlgorithm, key: String? = nil) -> String {
        let str = Array(self.utf8CString)
        let strLen = str.count-1
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLen)

        if let key = key {
            let keyStr = Array(key.utf8CString)
            let keyLen = keyStr.count-1
            CCHmac(algorithm.hmacAlgorithm, keyStr, keyLen, str, strLen, result)
        } else {
            _ = algorithm.digestAlgorithm(str, CC_LONG(strLen), result)
        }

        let digest = result.toHexString(count: digestLen)

        result.deallocate(capacity: digestLen)

        return digest
    }

}

extension Data : Hashing {

    public func digest(_ algorithm: CryptoAlgorithm, key: String? = nil) -> Data {
        let count = self.count
        let digestLen = algorithm.digestLength

        return self.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Data in
            let result = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLen)
            defer {
                result.deallocate(capacity: digestLen)
            }

            if let key = key {
                let keyStr = Array(key.utf8CString)
                let keyLen = keyStr.count-1
                CCHmac(algorithm.hmacAlgorithm, keyStr, keyLen, bytes, count, result)
            } else {
                _ = algorithm.digestAlgorithm(bytes, CC_LONG(count), result)
            }

            return Data(bytes: result, count: digestLen)
        }
    }

}

private extension UnsafeMutablePointer where Pointee == CUnsignedChar {

    func toHexString(count: Int) -> String {
        var result = String()
        for i in 0..<count {
            let s = String(self[i], radix: 16)
            if s.count % 2 == 1 {
                result.append("0"+s)
            } else {
                result.append(s)
            }
        }
        return result
    }

}
