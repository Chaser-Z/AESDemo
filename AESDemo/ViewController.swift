//
//  ViewController.swift
//  AESDemo
//
//  Created by Michael Qu on 05/09/2017.
//  Copyright © 2017 Michael Dev. All rights reserved.
//

import UIKit
import CryptoSwift
import MediaPlayer

class ViewController: UIViewController {
    
    private let key: [UInt8] = Array("HSKPandaWordVoid".utf8)
    private var currentPlayer: AVAudioPlayer?
    private let mp3URL = URL(fileURLWithPath: Bundle.main.path(forResource: "0102nc19", ofType: "mp3")!)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 加密解密字符串
    @IBAction func encryptAndDecryptString(_ sender: Any) {
        let input = "This is a test string"
        print("input : \(input)")
        
        let encrypted = myEncrypt(input)
        let base64 = myToBase64(encrypted)
        print("encrypted: \(base64)")
        print("expected : LJjn/4OyFzE5SV0SQJUaWur2973Z/t9aIeDMOvDzi7k=")
        
        let target = myFromBase64(base64)
        let decrypted = myDecrypt(target)
        print("output: \(decrypted)")

    }
    
    // 不解密播放测试 - 播放不了
    @IBAction func play(_ sender: Any) {
        do {
            currentPlayer = try AVAudioPlayer(contentsOf: mp3URL)
            currentPlayer?.enableRate = true
            currentPlayer?.rate = 0.8
            currentPlayer?.prepareToPlay()
            currentPlayer?.play()
        } catch {
            print("\(error)")
        }
    }
    
    // 不指定fileType解密播放 - 播放不了
    @IBAction func noFileTypeDecryptPlay(_ sender: Any) {
        let newData = AESTool.getDecryptData(url: mp3URL)
        
        do {
            currentPlayer = try AVAudioPlayer(data: newData)
            currentPlayer?.enableRate = true
            currentPlayer?.rate = 0.8
            currentPlayer?.prepareToPlay()
            currentPlayer?.play()
        } catch {
            print("\(error)")
        }
    }
    
    // 解密播放测试 - 播放成功
    @IBAction func decryptPlay(_ sender: Any) {
        let newData = AESTool.getDecryptData(url: mp3URL)
        
        do {
            currentPlayer = try AVAudioPlayer(data: newData, fileTypeHint: AVFileTypeMPEGLayer3)
            currentPlayer?.enableRate = true
            currentPlayer?.rate = 0.8
            currentPlayer?.prepareToPlay()
            currentPlayer?.play()
        } catch {
            print("\(error)")
        }
    }
    
    private func myEncrypt(_ input: String) -> [UInt8] {
        do {
            let data = input.data(using: String.Encoding.utf8)!
            let inputBytes: [UInt8] = data.bytes
            
            let encrypted = try AES(key: key, iv: nil, blockMode: .ECB).encrypt(inputBytes)
            return encrypted
        } catch {
            print("Failed to encrypt: \(error)")
        }
        
        return []
    }

    // TODO:
    private func myDecrypt(_ input: [UInt8]) -> String {
        do {
            let decrypted = try AES(key: key, iv: nil, blockMode: .ECB).decrypt(input)
            return String(bytes: decrypted, encoding: String.Encoding.utf8)!
        } catch {
            print("Failed to decrypt: \(error)")
        }
        
        return ""
    }
    
    
    private func myToBase64(_ input: [UInt8]) -> String {
        return input.toBase64()!
    }
    
    private func myFromBase64(_ input: String) -> [UInt8] {
        return Data(base64Encoded: input)!.bytes
    }
}

