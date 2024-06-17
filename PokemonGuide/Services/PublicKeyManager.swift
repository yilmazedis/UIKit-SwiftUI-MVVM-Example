//
//  PublicKeyManager.swift
//  PokemonGuide
//
//  Created by Yılmaz Edis on 15.06.2024.
//

import Foundation
import CommonCrypto

protocol PublicKeyManagerProtocol {
    func verify(_ publicKey: Data) -> Bool
    var localPublicKey: String { get }
}

final class PublicKeyManager: PublicKeyManagerProtocol {
    
    let localPublicKey = "Ud9Oxx5y+qyQ29XYWk7CD1oZVZ50uqrMVeowBnkRW6s="
    
    private let rsa2048Asn1Header: [UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
    
    private func hashPublicKey(publicKey: Data) -> String {
        var keyWithHeader = Data(rsa2048Asn1Header)
        keyWithHeader.append(publicKey)
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        
        keyWithHeader.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(keyWithHeader.count), &hash)
        }
        return Data(hash).base64EncodedString()
    }
    
    func verify(_ publicKey: Data) -> Bool {
        let hashedPublicKey = hashPublicKey(publicKey: publicKey)
        return hashedPublicKey == localPublicKey
    }
}
