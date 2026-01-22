//
//  Demo2ViewController.swift
//  SwiftUI10
//
//  Created by CQCA202121101_2 on 2026/1/22.
//

import UIKit
import LocalAuthentication
import Security
import CryptoKit

// MARK: - 扩展：Data转十六进制字符串
// 面试考点：如何安全地展示和处理二进制数据
extension Data {
    var hexString: String {
        return map { String(format: "%02x", $0) }.joined()
    }
}

// Demo 2 ViewController - Secure Enclave加密货币钱包完整示例
class Demo2ViewController: UIViewController {
    
    // MARK: - UI组件
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let generatePrivateKeyButton = UIButton(type: .system)
    private let encryptStoreButton = UIButton(type: .system)
    private let signTransactionButton = UIButton(type: .system)
    private let clearMemoryButton = UIButton(type: .system)
    private let resultTextView = UITextView()
    
    // MARK: - 数据
    private var bitcoinPrivateKey: Data? // 用户真正的比特币私钥（32字节）
    private var secureEnclavePrivateKey: SecKey? // Secure Enclave私钥
    private var secureEnclavePublicKey: SecKey? // Secure Enclave公钥
    private var encryptedBitcoinPrivateKey: Data? // 加密后的比特币私钥
    private let testTransactionData = "Bitcoin Transaction: Send 0.001 BTC to 1A1zP1eP5QGefi2DMPTfTL5SLmv7DivfNa".data(using: .utf8)! // 测试交易数据
    
    // Secure Enclave密钥标签
    private let secureEnclaveKeyTag = "com.example.secureenclave.bitcoin.wallet"
    private let encryptedKeychainTag = "com.example.keychain.encrypted.bitcoin.privatekey"
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Demo 2: Secure Enclave加密货币钱包"
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    // MARK: - UI设置
    private func setupUI() {
        // 设置滚动视图
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // 设置标题
        titleLabel.text = "Secure Enclave 加密货币钱包"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // 设置按钮
        generatePrivateKeyButton.setTitle("1. 生成比特币私钥", for: .normal)
        generatePrivateKeyButton.backgroundColor = .systemBlue
        generatePrivateKeyButton.setTitleColor(.white, for: .normal)
        generatePrivateKeyButton.layer.cornerRadius = 8
        generatePrivateKeyButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(generatePrivateKeyButton)
        
        encryptStoreButton.setTitle("2. 加密存储私钥", for: .normal)
        encryptStoreButton.backgroundColor = .systemGreen
        encryptStoreButton.setTitleColor(.white, for: .normal)
        encryptStoreButton.layer.cornerRadius = 8
        encryptStoreButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(encryptStoreButton)
        
        signTransactionButton.setTitle("3. 签名交易", for: .normal)
        signTransactionButton.backgroundColor = .systemPurple
        signTransactionButton.setTitleColor(.white, for: .normal)
        signTransactionButton.layer.cornerRadius = 8
        signTransactionButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(signTransactionButton)
        
        clearMemoryButton.setTitle("4. 清空内存私钥", for: .normal)
        clearMemoryButton.backgroundColor = .systemRed
        clearMemoryButton.setTitleColor(.white, for: .normal)
        clearMemoryButton.layer.cornerRadius = 8
        clearMemoryButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(clearMemoryButton)
        
        // 设置结果文本视图
        resultTextView.text = "操作结果将显示在这里\n\n" +
                            "流程说明：\n" +
                            "1. 生成32字节比特币私钥\n" +
                            "2. 创建Secure Enclave密钥对\n" +
                            "3. 用SE公钥加密私钥\n" +
                            "4. 将密文存入Keychain\n" +
                            "5. 交易时解密并签名\n" +
                            "6. 立即清零内存私钥"
        resultTextView.font = UIFont.systemFont(ofSize: 16)
        resultTextView.layer.borderWidth = 1
        resultTextView.layer.borderColor = UIColor.lightGray.cgColor
        resultTextView.layer.cornerRadius = 8
        resultTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(resultTextView)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 滚动视图约束
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // 内容视图约束
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 标题约束
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 生成私钥按钮约束
            generatePrivateKeyButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            generatePrivateKeyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            generatePrivateKeyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            generatePrivateKeyButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 加密存储按钮约束
            encryptStoreButton.topAnchor.constraint(equalTo: generatePrivateKeyButton.bottomAnchor, constant: 20),
            encryptStoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            encryptStoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            encryptStoreButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 签名交易按钮约束
            signTransactionButton.topAnchor.constraint(equalTo: encryptStoreButton.bottomAnchor, constant: 20),
            signTransactionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            signTransactionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            signTransactionButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 清空内存按钮约束
            clearMemoryButton.topAnchor.constraint(equalTo: signTransactionButton.bottomAnchor, constant: 20),
            clearMemoryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            clearMemoryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            clearMemoryButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 结果文本视图约束
            resultTextView.topAnchor.constraint(equalTo: clearMemoryButton.bottomAnchor, constant: 30),
            resultTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resultTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            resultTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            resultTextView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    // MARK: - 动作设置
    private func setupActions() {
        generatePrivateKeyButton.addTarget(self, action: #selector(generateBitcoinPrivateKey), for: .touchUpInside)
        encryptStoreButton.addTarget(self, action: #selector(encryptAndStorePrivateKey), for: .touchUpInside)
        signTransactionButton.addTarget(self, action: #selector(signTransaction), for: .touchUpInside)
        clearMemoryButton.addTarget(self, action: #selector(clearMemory), for: .touchUpInside)
    }
    
    // MARK: - 核心流程实现
    
    // 步骤1：生成比特币私钥（32字节）
    // 面试考点：如何安全生成加密货币私钥
    @objc private func generateBitcoinPrivateKey() {
        do {
            // 生成32字节随机私钥（比特币标准）
            var privateKeyBytes = [UInt8](repeating: 0, count: 32)
            let status = SecRandomCopyBytes(kSecRandomDefault, privateKeyBytes.count, &privateKeyBytes)
            guard status == errSecSuccess else {
                throw NSError(domain: "SecRandomError", code: Int(status), userInfo: nil)
            }
            
            // 存储私钥
            let privateKey = Data(privateKeyBytes)
            self.bitcoinPrivateKey = privateKey
            
            // 步骤2：创建Secure Enclave密钥对
            try createSecureEnclaveKeyPair()
            
            updateResult("✅ 比特币私钥生成成功\n" +
                        "私钥长度: 32字节\n" +
                        "私钥数据: \(privateKey.hexString)\n" +
                        "✅ Secure Enclave密钥对创建成功\n" +
                        "提示: 私钥已生成，可进行加密存储")
        } catch {
            updateResult("❌ 生成私钥失败: \(error.localizedDescription)")
        }
    }
    
    // 创建Secure Enclave密钥对
    // 面试考点：如何正确配置Secure Enclave密钥生成参数
    private func createSecureEnclaveKeyPair() throws {
        // 生成标签数据
        let tagData = secureEnclaveKeyTag.data(using: .utf8)! as CFData
        
        // RSA密钥对生成参数
        // 面试考点：Secure Enclave RSA密钥生成的关键参数
        let attributes: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 2048,
            kSecPrivateKeyAttrs as String: [
                kSecAttrApplicationTag as String: tagData,
                kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave,
                kSecAttrIsPermanent as String: false // 不存储到keychain，避免权限问题
            ]
        ]
        
        // 生成RSA密钥对
        // 面试考点：Secure Enclave的核心API调用
        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error),
              let publicKey = SecKeyCopyPublicKey(privateKey) else {
            throw error!.takeRetainedValue() as Error
        }
        
        // 存储密钥对
        self.secureEnclavePrivateKey = privateKey
        self.secureEnclavePublicKey = publicKey
    }
    
    // 步骤3-4：加密比特币私钥并存储到Keychain
    // 面试考点：如何安全加密和存储私钥
    @objc private func encryptAndStorePrivateKey() {
        do {
            guard let bitcoinPrivateKey = bitcoinPrivateKey, let publicKey = secureEnclavePublicKey else {
                throw NSError(domain: "KeyError", code: 0, userInfo: [NSLocalizedDescriptionKey: "请先生成比特币私钥"])
            }
            
            // 使用Secure Enclave公钥加密比特币私钥
            // 面试考点：RSA加密的核心API调用
            var error: Unmanaged<CFError>?
            guard let encryptedData = SecKeyCreateEncryptedData(
                publicKey,
                .rsaEncryptionOAEPSHA256,
                bitcoinPrivateKey as CFData,
                &error
            ) as Data? else {
                throw error!.takeRetainedValue() as Error
            }
            
            // 将加密后的私钥存储到Keychain
            // 面试考点：如何安全配置Keychain存储参数
            try storeEncryptedKeyToKeychain(encryptedData: encryptedData)
            
            // 存储加密数据到内存
            self.encryptedBitcoinPrivateKey = encryptedData
            
            updateResult("✅ 私钥加密存储成功\n" +
                        "加密数据长度: \(encryptedData.count) 字节\n" +
                        "加密数据: \(encryptedData.hexString)\n" +
                        "✅ 密文已存入Keychain\n" +
                        "提示: 可进行交易签名操作")
        } catch {
            updateResult("❌ 加密存储失败: \(error.localizedDescription)")
        }
    }
    
    // 将加密后的私钥存储到Keychain
    // 面试考点：Keychain安全存储的最佳实践
    private func storeEncryptedKeyToKeychain(encryptedData: Data) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: encryptedKeychainTag,
            kSecValueData as String: encryptedData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly, // 仅设备解锁时可访问，且仅本设备
            kSecAttrSynchronizable as String: false // 不同步到iCloud
        ]
        
        // 删除旧数据（如果存在）
        SecItemDelete(query as CFDictionary)
        
        // 存储新数据
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: nil)
        }
    }
    
    // 从Keychain读取加密后的私钥
    private func getEncryptedKeyFromKeychain() throws -> Data {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: encryptedKeychainTag,
            kSecReturnData as String: true,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else {
            throw NSError(domain: "KeychainError", code: Int(status), userInfo: nil)
        }
        
        return data
    }
    
    // 步骤5：交易签名（含内存清零）
    // 面试考点：如何安全进行交易签名并管理内存中的私钥
    @objc private func signTransaction() {
        do {
            // 从Keychain读取加密的私钥
            let encryptedPrivateKey = try getEncryptedKeyFromKeychain()
            
            guard let privateKey = secureEnclavePrivateKey else {
                throw NSError(domain: "KeyError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Secure Enclave私钥不存在"])
            }
            
            // 使用Secure Enclave私钥解密
            // 面试考点：Secure Enclave解密的核心API调用
            var error: Unmanaged<CFError>?
            guard let decryptedPrivateKey = SecKeyCreateDecryptedData(
                privateKey,
                .rsaEncryptionOAEPSHA256,
                encryptedPrivateKey as CFData,
                &error
            ) as Data? else {
                throw error!.takeRetainedValue() as Error
            }
            
            // 验证解密后的私钥长度
            guard decryptedPrivateKey.count == 32 else {
                throw NSError(domain: "DecryptionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "私钥长度不正确"])
            }
            
            // 使用比特币私钥签名交易
            // 面试考点：如何使用私钥进行数字签名
            let signature = try signWithBitcoinPrivateKey(privateKey: decryptedPrivateKey, data: testTransactionData)
            
            // 步骤5e：立即清零内存中的私钥
            // 面试考点：如何防止内存中的私钥泄露
            var mutablePrivateKey = decryptedPrivateKey
            mutablePrivateKey.resetBytes(in: 0..<mutablePrivateKey.count)
            
            updateResult("✅ 交易签名成功\n" +
                        "交易数据: \(String(data: testTransactionData, encoding: .utf8)!)\n" +
                        "签名数据: \(signature.hexString)\n" +
                        "✅ 内存私钥已清零\n" +
                        "提示: 签名完成，私钥已安全处理")
        } catch {
            updateResult("❌ 交易签名失败: \(error.localizedDescription)")
        }
    }
    
    // 使用比特币私钥签名交易数据
    // 注意：实际比特币交易签名更复杂，这里使用简化的ECDSA签名
    private func signWithBitcoinPrivateKey(privateKey: Data, data: Data) throws -> Data {
        // 这里使用CryptoKit进行ECDSA签名（模拟比特币签名）
        // 实际比特币使用secp256k1曲线，这里使用P256作为示例
        do {
            // 生成临时ECDSA密钥对进行签名
            let privateKey = try P256.Signing.PrivateKey(rawRepresentation: privateKey)
            let signature = try privateKey.signature(for: data)
            return signature.rawRepresentation
        } catch {
            // 如果私钥格式不适合P256，使用SHA256+HMAC作为演示
            let signature = HMAC<SHA256>.authenticationCode(for: data, using: SymmetricKey(data: privateKey))
            return Data(signature)
        }
    }
    
    // 步骤6：清空内存中的私钥
    // 面试考点：内存安全的最佳实践
    @objc private func clearMemory() {
        // 清零内存中的私钥
        if var privateKey = bitcoinPrivateKey {
            privateKey.resetBytes(in: 0..<privateKey.count)
            self.bitcoinPrivateKey = nil
        }
        
        if var encryptedKey = encryptedBitcoinPrivateKey {
            encryptedKey.resetBytes(in: 0..<encryptedKey.count)
            self.encryptedBitcoinPrivateKey = nil
        }
        
        // 重置Secure Enclave密钥
        self.secureEnclavePrivateKey = nil
        self.secureEnclavePublicKey = nil
        
        updateResult("✅ 内存私钥已清零\n" +
                    "✅ Secure Enclave密钥已重置\n" +
                    "提示: 所有敏感数据已从内存清除")
    }
    
    // MARK: - 辅助方法
    
    // 更新结果显示
    private func updateResult(_ text: String) {
        DispatchQueue.main.async {
            self.resultTextView.text = text
        }
    }
}

// MARK: - Secure Enclave 原理与面试考点
/*
Secure Enclave 核心原理：
1. 硬件隔离：独立于主处理器的硬件安全区域
2. 密钥保护：私钥在硬件内生成和存储，永不离开
3. 加密加速：专用硬件加速加密操作
4. 安全启动：独立的安全启动过程
5. 生物识别集成：直接与Touch ID/Face ID集成

面试考点总结：

1. 私钥生成与管理：
   - 如何安全生成32字节比特币私钥
   - 为什么使用SecRandomCopyBytes而不是其他随机方法
   - 私钥长度的重要性

2. Secure Enclave使用：
   - 如何正确配置RSA/ECDSA密钥生成参数
   - kSecAttrTokenIDSecureEnclave的作用
   - 为什么设置kSecAttrIsPermanent为false

3. 加密与存储：
   - RSA-OAEP-SHA256加密的优势
   - Keychain存储的最佳安全配置
   - kSecAttrAccessibleWhenUnlockedThisDeviceOnly的意义

4. 交易签名：
   - 如何使用解密后的私钥进行签名
   - 签名后立即清零内存的重要性
   - 实际比特币交易签名的复杂性

5. 内存安全：
   - 如何安全处理内存中的私钥
   - Data.resetBytes(in:)方法的作用
   - 防止内存转储攻击的措施

6. 错误处理：
   - SecKeyCreateRandomKey失败的常见原因
   - Keychain操作失败的处理
   - 生物识别失败的降级方案

7. 安全最佳实践：
   - 多因素认证的集成
   - 助记词备份的重要性
   - 应对越狱设备的策略

8. 性能考虑：
   - Secure Enclave操作的性能特点
   - 如何优化频繁签名的性能
   - 内存使用的优化

OKX等加密货币公司的面试问题：
1. 如何设计一个安全的加密货币钱包架构
2. Secure Enclave在钱包安全中的具体应用
3. 如何防止私钥在传输和存储过程中泄露
4. 交易签名的完整流程和安全保障
5. 多设备同步的安全实现方案
6. 设备丢失后的资产恢复机制
7. 如何应对侧信道攻击
8. Secure Enclave与其他安全方案的对比

实际应用建议：
1. 使用ECDSA而不是RSA（更适合加密货币）
2. 结合生物识别进行操作授权
3. 定期备份助记词
4. 实现设备绑定机制
5. 监控异常签名行为
*/
