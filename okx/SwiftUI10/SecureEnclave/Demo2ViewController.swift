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

// Demo 2 ViewController - Secure Enclave示例
class Demo2ViewController: UIViewController {
    
    // MARK: - UI组件
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let createKeyButton = UIButton(type: .system)
    private let encryptButton = UIButton(type: .system)
    private let decryptButton = UIButton(type: .system)
    private let signButton = UIButton(type: .system)
    private let verifyButton = UIButton(type: .system)
    private let resultTextView = UITextView()
    private let okxExampleButton = UIButton(type: .system)
    
    // MARK: - 数据
    private var publicKey: SecKey?
    private var privateKey: SecKey? // 保存私钥引用
    private var encryptedData: Data?
    private var signedData: Data?
    private let testMessage = "Hello, Secure Enclave!"
    
    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Demo 2: Secure Enclave示例"
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
        titleLabel.text = "Secure Enclave 演示"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // 设置按钮
        createKeyButton.setTitle("1. 创建密钥对", for: .normal)
        createKeyButton.backgroundColor = .systemBlue
        createKeyButton.setTitleColor(.white, for: .normal)
        createKeyButton.layer.cornerRadius = 8
        createKeyButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(createKeyButton)
        
        encryptButton.setTitle("2. RSA加密", for: .normal)
        encryptButton.backgroundColor = .systemGreen
        encryptButton.setTitleColor(.white, for: .normal)
        encryptButton.layer.cornerRadius = 8
        encryptButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(encryptButton)
        
        decryptButton.setTitle("3. RSA解密", for: .normal)
        decryptButton.backgroundColor = .systemOrange
        decryptButton.setTitleColor(.white, for: .normal)
        decryptButton.layer.cornerRadius = 8
        decryptButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(decryptButton)
        
        signButton.setTitle("4. 数字签名", for: .normal)
        signButton.backgroundColor = .systemPurple
        signButton.setTitleColor(.white, for: .normal)
        signButton.layer.cornerRadius = 8
        signButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(signButton)
        
        verifyButton.setTitle("5. 验证签名", for: .normal)
        verifyButton.backgroundColor = .systemPink
        verifyButton.setTitleColor(.white, for: .normal)
        verifyButton.layer.cornerRadius = 8
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(verifyButton)
        
        okxExampleButton.setTitle("6. OKX加密货币示例", for: .normal)
        okxExampleButton.backgroundColor = .systemRed
        okxExampleButton.setTitleColor(.white, for: .normal)
        okxExampleButton.layer.cornerRadius = 8
        okxExampleButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(okxExampleButton)
        
        // 设置结果文本视图
        resultTextView.text = "操作结果将显示在这里"
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
            
            // 创建密钥对按钮约束
            createKeyButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            createKeyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            createKeyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            createKeyButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 加密按钮约束
            encryptButton.topAnchor.constraint(equalTo: createKeyButton.bottomAnchor, constant: 20),
            encryptButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            encryptButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            encryptButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 解密按钮约束
            decryptButton.topAnchor.constraint(equalTo: encryptButton.bottomAnchor, constant: 20),
            decryptButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            decryptButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            decryptButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 签名按钮约束
            signButton.topAnchor.constraint(equalTo: decryptButton.bottomAnchor, constant: 20),
            signButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            signButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            signButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 验证签名按钮约束
            verifyButton.topAnchor.constraint(equalTo: signButton.bottomAnchor, constant: 20),
            verifyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            verifyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            verifyButton.heightAnchor.constraint(equalToConstant: 50),
            
            // OKX示例按钮约束
            okxExampleButton.topAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 20),
            okxExampleButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            okxExampleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            okxExampleButton.heightAnchor.constraint(equalToConstant: 50),
            
            // 结果文本视图约束
            resultTextView.topAnchor.constraint(equalTo: okxExampleButton.bottomAnchor, constant: 30),
            resultTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            resultTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            resultTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            resultTextView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    // MARK: - 动作设置
    private func setupActions() {
        createKeyButton.addTarget(self, action: #selector(createKeyPair), for: .touchUpInside)
        encryptButton.addTarget(self, action: #selector(encryptMessage), for: .touchUpInside)
        decryptButton.addTarget(self, action: #selector(decryptMessage), for: .touchUpInside)
        signButton.addTarget(self, action: #selector(signMessage), for: .touchUpInside)
        verifyButton.addTarget(self, action: #selector(verifySignature), for: .touchUpInside)
        okxExampleButton.addTarget(self, action: #selector(okxExample), for: .touchUpInside)
    }
    
    // MARK: - Secure Enclave 操作
    
    // 创建密钥对
    // 面试考点：如何在Secure Enclave中创建RSA密钥对
    @objc private func createKeyPair() {
        do {
            // 生成唯一的标签，用于标识密钥（仅用于演示，实际使用中不需要）
            let tag = "com.example.secureenclave.rsa.private".data(using: .utf8)! as CFData
            
            // 密钥对生成参数
            // 面试考点：Secure Enclave密钥生成的关键参数
            // 修复：移除kSecAttrIsPermanent参数，使用临时密钥
            let attributes: [String: Any] = [
                kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
                kSecAttrKeySizeInBits as String: 2048,
                kSecPrivateKeyAttrs as String: [
                    kSecAttrApplicationTag as String: tag,
                    kSecAttrTokenID as String: kSecAttrTokenIDSecureEnclave
                ]
            ]
            
            // 生成密钥对
            // 面试考点：Secure Enclave的核心API调用
            var error: Unmanaged<CFError>?
            guard let privateKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error),
                  let publicKey = SecKeyCopyPublicKey(privateKey) else {
                throw error!.takeRetainedValue() as Error
            }
            
            self.privateKey = privateKey
            self.publicKey = publicKey
            
            // 获取公钥数据（用于传输）
            let publicKeyData = getPublicKeyData(publicKey: publicKey)
            
            updateResult("✅ 密钥对创建成功\n" +
                        "公钥长度: \(publicKeyData.count) 字节\n" +
                        "密钥存储在Secure Enclave中，私钥无法被提取")
        } catch {
            updateResult("❌ 创建密钥对失败: \(error.localizedDescription)")
        }
    }
    
    // RSA加密
    @objc private func encryptMessage() {
        guard let publicKey = publicKey else {
            updateResult("❌ 请先创建密钥对")
            return
        }
        
        do {
            let messageData = testMessage.data(using: .utf8)! as CFData
            
            // 使用公钥加密
            // 面试考点：RSA加密的核心API调用
            var error: Unmanaged<CFError>?
            guard let encryptedData = SecKeyCreateEncryptedData(
                publicKey,
                .rsaEncryptionOAEPSHA256,
                messageData,
                &error
            ) as Data? else {
                throw error!.takeRetainedValue() as Error
            }
            
            self.encryptedData = encryptedData
            
            updateResult("✅ 加密成功\n" +
                        "原始消息: \(testMessage)\n" +
                        "加密后数据长度: \(encryptedData.count) 字节\n" +
                        "加密数据: \(encryptedData.base64EncodedString())")
        } catch {
            updateResult("❌ 加密失败: \(error.localizedDescription)")
        }
    }
    
    // RSA解密
    // 面试考点：如何在不获取私钥的情况下使用Secure Enclave进行解密
    @objc private func decryptMessage() {
        guard let encryptedData = encryptedData, let privateKey = privateKey else {
            updateResult("❌ 请先创建密钥对并加密消息")
            return
        }
        
        do {
            
            // 使用私钥解密（私钥始终在Secure Enclave中，不会被提取）
            // 面试考点：Secure Enclave解密的核心API调用
            var error: Unmanaged<CFError>?
            guard let decryptedData = SecKeyCreateDecryptedData(
                privateKey,
                .rsaEncryptionOAEPSHA256,
                encryptedData as CFData,
                &error
            ) as Data? else {
                throw error!.takeRetainedValue() as Error
            }
            
            guard let decryptedMessage = String(data: decryptedData, encoding: .utf8) else {
                throw NSError(domain: "DecryptionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert decrypted data to string"])
            }
            
            updateResult("✅ 解密成功\n" +
                        "解密后消息: \(decryptedMessage)\n" +
                        "注意: 私钥始终在Secure Enclave中，未被提取")
        } catch {
            updateResult("❌ 解密失败: \(error.localizedDescription)")
        }
    }
    
    // 数字签名
    // 面试考点：如何使用Secure Enclave进行数字签名
    @objc private func signMessage() {
        guard let privateKey = privateKey else {
            updateResult("❌ 请先创建密钥对")
            return
        }
        
        do {
            
            let messageData = testMessage.data(using: .utf8)! as CFData
            
            // 使用私钥签名（私钥始终在Secure Enclave中）
            // 面试考点：Secure Enclave数字签名的核心API调用
            var error: Unmanaged<CFError>?
            guard let signedData = SecKeyCreateSignature(
                privateKey,
                .rsaSignatureMessagePKCS1v15SHA256,
                messageData,
                &error
            ) as Data? else {
                throw error!.takeRetainedValue() as Error
            }
            
            self.signedData = signedData
            
            updateResult("✅ 签名成功\n" +
                        "签名数据长度: \(signedData.count) 字节\n" +
                        "签名数据: \(signedData.base64EncodedString())")
        } catch {
            updateResult("❌ 签名失败: \(error.localizedDescription)")
        }
    }
    
    // 验证签名
    @objc private func verifySignature() {
        guard let publicKey = publicKey, let signedData = signedData else {
            updateResult("❌ 请先创建密钥对并签名消息")
            return
        }
        
        do {
            let messageData = testMessage.data(using: .utf8)! as CFData
            
            // 使用公钥验证签名
            // 面试考点：RSA签名验证的核心API调用
            var error: Unmanaged<CFError>?
            let isValid = SecKeyVerifySignature(
                publicKey,
                .rsaSignatureMessagePKCS1v15SHA256,
                messageData,
                signedData as CFData,
                &error
            )
            
            if isValid {
                updateResult("✅ 签名验证成功\n" +
                            "消息完整性得到确认")
            } else {
                throw error!.takeRetainedValue() as Error
            }
        } catch {
            updateResult("❌ 签名验证失败: \(error.localizedDescription)")
        }
    }
    
    // OKX加密货币示例
    @objc private func okxExample() {
        updateResult("🔐 OKX加密货币Secure Enclave应用场景\n\n" +
                    "1. 私钥管理\n" +
                    "   - 加密货币钱包的私钥存储在Secure Enclave中\n" +
                    "   - 私钥无法被提取，即使设备被越狱\n" +
                    "   - 交易签名在Secure Enclave内部完成\n\n" +
                    "2. 交易签名\n" +
                    "   - 用户发起交易时，交易数据发送到Secure Enclave\n" +
                    "   - Secure Enclave使用私钥签名交易\n" +
                    "   - 签名后的数据返回给应用，然后广播到网络\n\n" +
                    "3. 身份验证\n" +
                    "   - 使用Secure Enclave存储的密钥进行设备身份验证\n" +
                    "   - 防止未授权设备访问账户\n\n" +
                    "4. 多因素认证\n" +
                    "   - 结合生物识别（Touch ID/Face ID）和Secure Enclave\n" +
                    "   - 提供更高级别的账户保护\n\n" +
                    "5. 恢复机制\n" +
                    "   - 使用助记词作为备份，而非私钥\n" +
                    "   - 即使设备丢失，也可以通过助记词恢复钱包\n\n" +
                    "实现方案：\n" +
                    "- 使用上述的Secure Enclave API存储RSA或ECDSA密钥\n" +
                    "- 交易签名时调用SecKeyCreateSignature\n" +
                    "- 结合LocalAuthentication框架实现生物识别\n" +
                    "- 定期备份助记词，确保资产安全")
    }
    
    // MARK: - 辅助方法
    
    // 获取公钥数据
    private func getPublicKeyData(publicKey: SecKey) -> Data {
        var error: Unmanaged<CFError>?
        guard let publicKeyData = SecKeyCopyExternalRepresentation(publicKey, &error) as Data? else {
            fatalError("Failed to get public key data: \(error!.takeRetainedValue())")
        }
        return publicKeyData
    }
    
    // 更新结果显示
    private func updateResult(_ text: String) {
        DispatchQueue.main.async {
            self.resultTextView.text = text
        }
    }
}

// MARK: - Secure Enclave 原理与优势
/*
Secure Enclave 原理：
1. 硬件隔离：Secure Enclave是一个独立的硬件区域，与主处理器隔离
2. 加密引擎：内置专用的加密引擎，用于密钥生成和加密操作
3. 密钥保护：私钥在Secure Enclave中生成并存储，永远不会离开该环境
4. 安全启动：Secure Enclave有自己的安全启动过程，防止被篡改
5. 生物识别集成：直接与Touch ID/Face ID硬件集成，提供更安全的身份验证

Secure Enclave 优势：
1. 最高安全性：硬件级别的安全保障，远高于软件加密
2. 私钥不可提取：即使设备被越狱，私钥也无法被获取
3. 防篡改：硬件隔离防止攻击者篡改加密操作
4. 高性能：专用硬件加速加密操作
5. 便捷使用：与iOS系统深度集成，使用简单

面试考点总结：
1. Secure Enclave的基本原理和硬件架构
2. 如何在Secure Enclave中创建和使用密钥
3. 私钥无法被提取的实现机制
4. RSA和ECDSA在Secure Enclave中的使用场景
5. Secure Enclave与生物识别的集成方式
6. 加密货币钱包中Secure Enclave的应用
7. Secure Enclave的局限性和替代方案
8. 如何处理Secure Enclave的错误和异常情况

OKX等加密货币公司的面试问题：
1. 如何设计一个安全的加密货币钱包
2. Secure Enclave在钱包安全中的作用
3. 如何防止私钥泄露
4. 交易签名的安全实现方案
5. 多因素认证的最佳实践
6. 设备丢失后的资产恢复方案
7. 如何应对越狱设备的安全挑战
8. Secure Enclave与其他安全存储方案的对比
*/

// MARK: - ECDSA示例（加密货币常用算法）
/*
// 注意：以下代码需要iOS 13+，使用CryptoKit框架
import CryptoKit

// 创建ECDSA密钥对（用于加密货币）
func createECDSAKeyPair() throws -> (privateKey: SecureEnclave.P256.Signing.PrivateKey, publicKey: SecureEnclave.P256.Signing.PublicKey) {
    // 生成ECDSA密钥对（P256曲线，加密货币常用）
    let privateKey = try SecureEnclave.P256.Signing.PrivateKey()
    let publicKey = privateKey.publicKey
    return (privateKey, publicKey)
}

// 使用ECDSA签名交易
func signTransaction(transactionData: Data, privateKey: SecureEnclave.P256.Signing.PrivateKey) throws -> Data {
    let signature = try privateKey.signature(for: transactionData)
    return signature.rawRepresentation
}

// 验证ECDSA签名
func verifyTransaction(transactionData: Data, signature: Data, publicKey: SecureEnclave.P256.Signing.PublicKey) throws -> Bool {
    let signature = try P256.Signing.ECDSASignature(rawRepresentation: signature)
    return publicKey.isValidSignature(signature, for: transactionData)
}
*/
