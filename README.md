# AESDemo
# 首先是这样的，公司需要对音频文件进行加密，服务端进行AES加密，客户端进行解密的。


## 一、前期准备
### 1.  然后在GitHub上找到一个三方处理加密解密的 [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift)
### 2. 简单封装了一下解密的方法

需要公司给定key

```
// MARK: - AESkey
static let AESkey: [UInt8] = Array("公司后台加密的key".utf8)
open static let shared = AESTool()
```

获取播放链接并转化成解密后data

```
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
        	  // blockMode: .ECB 我们公司后台加密AES是ECB类型
            let decrypted = try AES(key: AESkey, iv: nil, blockMode: .ECB).decrypt(input)
            return decrypted
        } catch {
            print("Failed to decrypt: \(error)")
        }
        return []
    }
```


## 二、开始测试
### 1.首先测试一下，是否真的不能播放

```
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
```

 果然播放不了。。。

### 2.不指定fileType解密播放

```
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
```
因为平时都是url播放的，没用过data播放，开始也没有指定fileType，发现一直失败，看打印错误才找到原因


### 3. 解密播放测试，指定fileType

```
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
```

发现终于成功了


