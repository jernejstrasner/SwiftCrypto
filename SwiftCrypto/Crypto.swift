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

enum CryptoAlgorithm {
    case md5, sha1, sha224, sha256, sha384, sha512

    var HMACAlgorithm: CCHmacAlgorithm {
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

    typealias DigestAlgorithm = (UnsafeRawPointer, CC_LONG, UnsafeMutablePointer<CUnsignedChar>) -> UnsafeMutablePointer<CUnsignedChar>!

    var digestAlgorithm: DigestAlgorithm {
        switch self {
        case .md5:      return CC_MD5
        case .sha1:     return CC_SHA1
        case .sha224:   return CC_SHA224
        case .sha256:   return CC_SHA256
        case .sha384:   return CC_SHA384
        case .sha512:   return CC_SHA512
        }
    }

    var digestLength: Int {
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

extension String {

    // MARK: HMAC

    func hmac(_ algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))

        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)

        let digest = stringFromResult(result, length: digestLen)

        result.deallocate(capacity: digestLen)

        return digest
    }

    // MARK: Digest

    var md5: String {
        return digest(.md5)
    }

    var sha1: String {
        return digest(.sha1)
    }

    var sha224: String {
        return digest(.sha224)
    }

    var sha256: String {
        return digest(.sha256)
    }

    var sha384: String {
        return digest(.sha384)
    }

    var sha512: String {
        return digest(.sha512)
    }

    func digest(_ algorithm: CryptoAlgorithm) -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)

        _ = algorithm.digestAlgorithm(str!, strLen, result)

        let digest = stringFromResult(result, length: digestLen)

        result.deallocate(capacity: digestLen)

        return digest
    }

    // MARK: Private

    fileprivate func stringFromResult(_ result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
    
}
