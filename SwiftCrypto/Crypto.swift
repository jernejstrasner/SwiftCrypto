//
//  Crypto.swift
//  SwiftCrypto
//
//  Created by Jernej Strasner on 10/13/14.
//  Copyright (c) 2014 Jernej Strasner. All rights reserved.
//

import Foundation

enum CryptoAlgorithm {
	case MD5, SHA1, SHA224, SHA256, SHA384, SHA512

    var HMACAlgorithm: CCHmacAlgorithm {
		var result: Int = 0
		switch self {
		case .MD5:		result = kCCHmacAlgMD5
		case .SHA1:		result = kCCHmacAlgSHA1
		case .SHA224:	result = kCCHmacAlgSHA224
		case .SHA256:	result = kCCHmacAlgSHA256
		case .SHA384:	result = kCCHmacAlgSHA384
		case .SHA512:	result = kCCHmacAlgSHA512
		}
		return CCHmacAlgorithm(result)
	}

    typealias DigestAlgorithm = (UnsafePointer<Void>, CC_LONG, UnsafeMutablePointer<CUnsignedChar>) -> UnsafeMutablePointer<CUnsignedChar>

    var digestAlgorithm: DigestAlgorithm {
        switch self {
        case .MD5:      return CC_MD5
        case .SHA1:     return CC_SHA1
        case .SHA224:   return CC_SHA224
        case .SHA256:   return CC_SHA256
        case .SHA384:   return CC_SHA384
        case .SHA512:   return CC_SHA512
        }
    }

    var digestLength: Int {
        var result: CInt = 0
        switch self {
        case .MD5:		result = CC_MD5_DIGEST_LENGTH
        case .SHA1:		result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:	result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:	result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:	result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:	result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {

    // MARK: HMAC

    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = UInt(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        let objcKey = key as NSString
        let keyStr = objcKey.cStringUsingEncoding(NSUTF8StringEncoding)
        let keyLen = UInt(objcKey.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))

        CCHmac(algorithm.HMACAlgorithm, keyStr, keyLen, str!, strLen, result)

        let digest = stringFromResult(result, length: digestLen)

        result.destroy()

        return digest
    }

    // MARK: Digest

    var md5: String {
        return digest(.MD5)
    }

    var sha1: String {
        return digest(.SHA1)
    }

    var sha224: String {
        return digest(.SHA224)
    }

    var sha256: String {
        return digest(.SHA256)
    }

    var sha384: String {
        return digest(.SHA384)
    }

    var sha512: String {
        return digest(.SHA512)
    }

    func digest(algorithm: CryptoAlgorithm) -> String {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)

        algorithm.digestAlgorithm(str!, strLen, result)

        let digest = stringFromResult(result, length: digestLen)

        result.destroy()

        return digest
    }

    // MARK: Private

    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        var hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
    
}