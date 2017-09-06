//
//  AESTool.swift
//  hanwordTe
//
//  Created by 张海南 on 2017/9/5.
//  Copyright © 2017年 user1. All rights reserved.
//

import UIKit
import CryptoSwift

class AESTool {
    
    // MARK: - AESkey
    static let AESkey: [UInt8] = Array("HSKPandaWordVoid".utf8)
    
    open static let shared = AESTool()
    
    
    class func getDecryptData(url: URL) -> Data {
        do {
            let data = try Data(contentsOf: url)
            let test = self.decrypt(data.bytes)
            let newData = Data(bytes: test)
            return newData

        } catch {
            print("Failed to getDecryptData: \(error)")
        }
        return Data()
    }

    class func decrypt(_ input: [UInt8]) -> [UInt8] {
        do {
            let decrypted = try AES(key: AESkey, iv: nil, blockMode: .ECB).decrypt(input)
            return decrypted
        } catch {
            print("Failed to decrypt: \(error)")
        }
        return []
    }

    
}
