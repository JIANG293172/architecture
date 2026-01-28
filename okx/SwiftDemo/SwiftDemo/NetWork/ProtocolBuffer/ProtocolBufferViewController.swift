import UIKit
import Foundation

/// Protocol Buffer 演示视图控制器
/// 本示例展示了 Protocol Buffer 在 iOS 中的完整落地实现
/// 包含类型定义、字节格式、序列化/反序列化、网络传输等示例
class ProtocolBufferViewController: UIViewController {
    
    /// 显示演示结果的文本视图
    private let resultTextView = UITextView()
    /// 演示类型选择分段控件
    private let demoTypeSegmentedControl = UISegmentedControl()
    /// 执行演示按钮
    private let executeButton = UIButton(type: .system)
    /// 保存演示结果
    private var results: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Protocol Buffer Demo"
        view.backgroundColor = .white
        setupUI()
        setupActions()
    }
    
    /// 设置用户界面
    private func setupUI() {
        // 设置分段控件
        demoTypeSegmentedControl.frame = CGRect(x: 50, y: 100, width: view.frame.width - 100, height: 40)
        demoTypeSegmentedControl.insertSegment(withTitle: "基本类型示例", at: 0, animated: false)
        demoTypeSegmentedControl.insertSegment(withTitle: "嵌套消息示例", at: 1, animated: false)
        demoTypeSegmentedControl.insertSegment(withTitle: "网络传输示例", at: 2, animated: false)
        demoTypeSegmentedControl.insertSegment(withTitle: "性能对比", at: 3, animated: false)
        demoTypeSegmentedControl.selectedSegmentIndex = 0
        view.addSubview(demoTypeSegmentedControl)
        
        // 设置执行按钮
        executeButton.frame = CGRect(x: 100, y: 160, width: view.frame.width - 200, height: 44)
        executeButton.setTitle("执行演示", for: .normal)
        executeButton.setTitleColor(.white, for: .normal)
        executeButton.backgroundColor = .blue
        executeButton.layer.cornerRadius = 22
        view.addSubview(executeButton)
        
        // 设置结果文本视图
        resultTextView.frame = CGRect(x: 50, y: 220, width: view.frame.width - 100, height: 400)
        resultTextView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        resultTextView.textColor = .black
        resultTextView.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        resultTextView.isEditable = false
        resultTextView.layer.borderWidth = 1.0
        resultTextView.layer.borderColor = UIColor.gray.cgColor
        resultTextView.layer.cornerRadius = 8.0
        resultTextView.text = "演示结果将显示在这里..."
        view.addSubview(resultTextView)
    }
    
    /// 设置按钮动作
    private func setupActions() {
        executeButton.addTarget(self, action: #selector(executeButtonTapped), for: .touchUpInside)
    }
    
    /// 执行演示按钮点击事件
    @objc private func executeButtonTapped() {
        results.removeAll()
        
        switch demoTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            runBasicTypesDemo()
        case 1:
            runNestedMessageDemo()
        case 2:
            runNetworkTransmissionDemo()
        case 3:
            runPerformanceComparisonDemo()
        default:
            break
        }
        
        updateResultTextView()
    }
    
    /// 基本类型示例
    private func runBasicTypesDemo() {
        appendResult("=== 基本类型示例 ===")
        
        // 创建用户消息
        let user = PBUser()
        user.id = 1
        user.name = "张三"
        user.email = "zhangsan@example.com"
        user.isActive = true
        user.score = 95.5
        user.tags = ["iOS", "Developer", "ProtocolBuffer"]
        
        appendResult("原始消息:")
        appendResult("ID: \(user.id)")
        appendResult("Name: \(user.name)")
        appendResult("Email: \(user.email)")
        appendResult("Is Active: \(user.isActive)")
        appendResult("Score: \(user.score)")
        appendResult("Tags: \(user.tags)")
        
        // 序列化
        do {
            let data = try user.serializedData()
            appendResult("\n序列化后的字节数据:")
            appendResult("字节长度: \(data.count)")
            appendResult("字节内容: \(data.pbHexString())")
            
            // 反序列化
            let deserializedUser = try PBUser(serializedData: data)
            appendResult("\n反序列化后的消息:")
            appendResult("ID: \(deserializedUser.id)")
            appendResult("Name: \(deserializedUser.name)")
            appendResult("Email: \(deserializedUser.email)")
            appendResult("Is Active: \(deserializedUser.isActive)")
            appendResult("Score: \(deserializedUser.score)")
            appendResult("Tags: \(deserializedUser.tags)")
        } catch {
            appendResult("\n错误: \(error.localizedDescription)")
        }
        
        appendResult("\n=== 基本类型示例结束 ===")
    }
    
    /// 嵌套消息示例
    private func runNestedMessageDemo() {
        appendResult("=== 嵌套消息示例 ===")
        
        // 创建地址消息
        let address = Address()
        address.street = "科技园路"
        address.city = "深圳"
        address.province = "广东"
        address.zipCode = "518000"
        
        // 创建公司消息
        let company = Company()
        company.name = "科技有限公司"
        company.address = address
        company.employeeCount = 100
        
        // 创建用户消息（包含公司信息）
        let user = PBUser()
        user.id = 2
        user.name = "李四"
        user.email = "lisi@example.com"
        user.company = company
        
        appendResult("原始嵌套消息:")
        appendResult("用户: \(user.name)")
        appendResult("公司: \(user.company?.name ?? "")")
        appendResult("公司地址: \(user.company?.address?.street ?? ""), \(user.company?.address?.city ?? "")")
        
        // 序列化
        do {
            let data = try user.serializedData()
            appendResult("\n序列化后的字节数据:")
            appendResult("字节长度: \(data.count)")
            appendResult("字节内容: \(data.pbHexString())")
            
            // 反序列化
            let deserializedUser = try PBUser(serializedData: data)
            appendResult("\n反序列化后的嵌套消息:")
            appendResult("用户: \(deserializedUser.name)")
            appendResult("公司: \(deserializedUser.company?.name ?? "")")
            appendResult("公司地址: \(deserializedUser.company?.address?.street ?? ""), \(deserializedUser.company?.address?.city ?? "")")
        } catch {
            appendResult("\n错误: \(error.localizedDescription)")
        }
        
        appendResult("\n=== 嵌套消息示例结束 ===")
    }
    
    /// 网络传输示例
    private func runNetworkTransmissionDemo() {
        appendResult("=== 网络传输示例 ===")
        
        // 模拟创建网络请求消息
        let request = APIRequest()
        request.type = APIRequest.RequestType.login
        request.timestamp = Int64(Date().timeIntervalSince1970 * 1000)
        
        // 设置登录参数
        let loginParams = LoginParams()
        loginParams.username = "testuser"
        loginParams.password = "password123"
        request.loginParams = loginParams
        
        appendResult("请求消息:")
        appendResult("类型: \(request.type)")
        appendResult("时间戳: \(request.timestamp)")
        appendResult("用户名: \(request.loginParams?.username ?? "")")
        
        // 序列化
        do {
            let data = try request.serializedData()
            appendResult("\n序列化后的请求数据:")
            appendResult("字节长度: \(data.count)")
            appendResult("字节内容: \(data.pbHexString())")
            
            // 模拟网络传输（这里只是演示，实际项目中会通过网络发送）
            appendResult("\n模拟网络传输...")
            
            // 模拟服务器响应
            let response = APIResponse()
            response.code = 200
            response.message = "Login successful"
            
            let userInfo = UserInfo()
            userInfo.id = 1001
            userInfo.username = "testuser"
            userInfo.nickname = "测试用户"
            userInfo.avatar = "https://example.com/avatar.jpg"
            response.userInfo = userInfo
            
            let responseData = try response.serializedData()
            appendResult("\n服务器响应数据:")
            appendResult("字节长度: \(responseData.count)")
            appendResult("字节内容: \(responseData.pbHexString())")
            
            // 反序列化响应
            let deserializedResponse = try APIResponse(serializedData: responseData)
            appendResult("\n反序列化后的响应:")
            appendResult("Code: \(deserializedResponse.code)")
            appendResult("Message: \(deserializedResponse.message)")
            appendResult("User ID: \(deserializedResponse.userInfo.id)")
            appendResult("Username: \(deserializedResponse.userInfo.username)")
            appendResult("Nickname: \(deserializedResponse.userInfo.nickname)")
        } catch {
            appendResult("\n错误: \(error.localizedDescription)")
        }
        
        appendResult("\n=== 网络传输示例结束 ===")
    }
    
    /// 性能对比示例
    private func runPerformanceComparisonDemo() {
        appendResult("=== 性能对比示例 ===")
        
        // 创建测试数据
        let user = PBUser()
        user.id = 1
        user.name = "测试用户"
        user.email = "test@example.com"
        user.isActive = true
        user.score = 90.5
        user.tags = ["iOS", "Developer", "ProtocolBuffer", "Performance", "Test"]
        
        let address = Address()
        address.street = "测试街道"
        address.city = "测试城市"
        address.province = "测试省份"
        address.zipCode = "123456"
        
        let company = Company()
        company.name = "测试公司"
        company.address = address
        company.employeeCount = 500
        user.company = company
        
        // Protocol Buffer 性能测试
        let pbStart = Date()
        do {
            for _ in 0..<1000 {
                let data = try user.serializedData()
                _ = try PBUser(serializedData: data)
            }
        } catch {
            appendResult("Protocol Buffer 测试错误: \(error.localizedDescription)")
            return
        }
        let pbEnd = Date()
        let pbTime = pbEnd.timeIntervalSince(pbStart) * 1000 // 毫秒
        
        // JSON 性能测试 - 创建一个简单的结构体用于对比
        struct JSONUser: Codable {
            let id: Int32
            let name: String
            let email: String
            let isActive: Bool
            let score: Double
            let tags: [String]
            let company: JSONCompany?
            
            struct JSONCompany: Codable {
                let name: String
                let employeeCount: Int32
                let address: JSONAddress?
                
                struct JSONAddress: Codable {
                    let street: String
                    let city: String
                    let province: String
                    let zipCode: String
                }
            }
        }
        
        let jsonUser = JSONUser(
            id: user.id,
            name: user.name,
            email: user.email,
            isActive: user.isActive,
            score: user.score,
            tags: user.tags,
            company: JSONUser.JSONCompany(
                name: company.name,
                employeeCount: company.employeeCount,
                address: JSONUser.JSONCompany.JSONAddress(
                    street: address.street,
                    city: address.city,
                    province: address.province,
                    zipCode: address.zipCode
                )
            )
        )
        
        let jsonStart = Date()
        do {
            for _ in 0..<1000 {
                let jsonData = try JSONEncoder().encode(jsonUser)
                _ = try JSONDecoder().decode(JSONUser.self, from: jsonData)
            }
        } catch {
            appendResult("JSON 测试错误: \(error.localizedDescription)")
            return
        }
        let jsonEnd = Date()
        let jsonTime = jsonEnd.timeIntervalSince(jsonStart) * 1000 // 毫秒
        
        // 序列化大小对比
        do {
            let pbData = try user.serializedData()
            let jsonData = try JSONEncoder().encode(jsonUser)
            
            appendResult("序列化大小对比:")
            appendResult("Protocol Buffer: \(pbData.count) 字节")
            appendResult("JSON: \(jsonData.count) 字节")
            appendResult("压缩比例: \(String(format: "%.2f%%", Double(pbData.count) / Double(jsonData.count) * 100))")
            
            appendResult("\n性能对比 (1000次序列化/反序列化):")
            appendResult("Protocol Buffer: \(String(format: "%.2f", pbTime)) 毫秒")
            appendResult("JSON: \(String(format: "%.2f", jsonTime)) 毫秒")
            appendResult("性能提升: \(String(format: "%.2f%%", (jsonTime - pbTime) / jsonTime * 100))")
        } catch {
            appendResult("大小对比错误: \(error.localizedDescription)")
        }
        
        appendResult("\n=== 性能对比示例结束 ===")
    }
    
    /// 追加结果
    private func appendResult(_ text: String) {
        results.append(text)
    }
    
    /// 更新结果文本视图
    private func updateResultTextView() {
        resultTextView.text = results.joined(separator: "\n")
        // 滚动到底部
        let bottom = NSMakeRange(resultTextView.text.count - 1, 1)
        resultTextView.scrollRangeToVisible(bottom)
    }
}

/// 扩展 Data 以显示十六进制字符串
extension Data {
    func pbHexString() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}

/// 模拟 Protocol Buffer 生成的代码
/// 实际项目中，这些代码会由 protoc 编译器自动生成

// 用户消息
class PBUser {
    var id: Int32 = 0
    var name: String = ""
    var email: String = ""
    var isActive: Bool = false
    var score: Double = 0.0
    var tags: [String] = []
    var company: Company? = nil
    
    /// 序列化
    func serializedData() throws -> Data {
        var data = Data()
        
        // 序列化 id (varint)
        data.append(encodeVarint(fieldNumber: 1, wireType: 0, value: UInt64(id)))
        
        // 序列化 name (string)
        data.append(encodeString(fieldNumber: 2, value: name))
        
        // 序列化 email (string)
        data.append(encodeString(fieldNumber: 3, value: email))
        
        // 序列化 isActive (bool)
        data.append(encodeBool(fieldNumber: 4, value: isActive))
        
        // 序列化 score (double)
        data.append(encodeDouble(fieldNumber: 5, value: score))
        
        // 序列化 tags (repeated string)
        for tag in tags {
            data.append(encodeString(fieldNumber: 6, value: tag))
        }
        
        // 序列化 company (nested message)
        if let company = company {
            let companyData = try company.serializedData()
            data.append(encodeMessage(fieldNumber: 7, value: companyData))
        }
        
        return data
    }
    
    /// 反序列化
    convenience init(serializedData: Data) throws {
        self.init()
        var index = 0
        
        while index < serializedData.count {
            let (fieldNumber, wireType, bytesRead) = decodeTag(data: serializedData, index: index)
            index += bytesRead
            
            switch fieldNumber {
            case 1: // id
                if wireType == 0 {
                    let (value, bytesRead) = decodeVarint(data: serializedData, index: index)
                    id = Int32(value)
                    index += bytesRead
                }
            case 2: // name
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    name = value
                    index += bytesRead
                }
            case 3: // email
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    email = value
                    index += bytesRead
                }
            case 4: // isActive
                if wireType == 0 {
                    let (value, bytesRead) = decodeVarint(data: serializedData, index: index)
                    isActive = value != 0
                    index += bytesRead
                }
            case 5: // score
                if wireType == 1 {
                    score = decodeDouble(data: serializedData, index: index)
                    index += 8
                }
            case 6: // tags
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    tags.append(value)
                    index += bytesRead
                }
            case 7: // company
                if wireType == 2 {
                    let (length, bytesRead) = decodeVarint(data: serializedData, index: index)
                    index += bytesRead
                    let companyData = serializedData.subdata(in: index..<index+Int(length))
                    company = try Company(serializedData: companyData)
                    index += Int(length)
                }
            default:
                // 跳过未知字段
                index += skipField(data: serializedData, index: index, wireType: wireType)
            }
        }
    }
}

// 公司消息
class Company {
    var name: String = ""
    var address: Address? = nil
    var employeeCount: Int32 = 0
    
    /// 序列化
    func serializedData() throws -> Data {
        var data = Data()
        
        // 序列化 name
        data.append(encodeString(fieldNumber: 1, value: name))
        
        // 序列化 address
        if let address = address {
            let addressData = try address.serializedData()
            data.append(encodeMessage(fieldNumber: 2, value: addressData))
        }
        
        // 序列化 employeeCount
        data.append(encodeVarint(fieldNumber: 3, wireType: 0, value: UInt64(employeeCount)))
        
        return data
    }
    
    /// 反序列化
    convenience init(serializedData: Data) throws {
        self.init()
        var index = 0
        
        while index < serializedData.count {
            let (fieldNumber, wireType, bytesRead) = decodeTag(data: serializedData, index: index)
            index += bytesRead
            
            switch fieldNumber {
            case 1: // name
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    name = value
                    index += bytesRead
                }
            case 2: // address
                if wireType == 2 {
                    let (length, bytesRead) = decodeVarint(data: serializedData, index: index)
                    index += bytesRead
                    let addressData = serializedData.subdata(in: index..<index+Int(length))
                    address = try Address(serializedData: addressData)
                    index += Int(length)
                }
            case 3: // employeeCount
                if wireType == 0 {
                    let (value, bytesRead) = decodeVarint(data: serializedData, index: index)
                    employeeCount = Int32(value)
                    index += bytesRead
                }
            default:
                index += skipField(data: serializedData, index: index, wireType: wireType)
            }
        }
    }
}

// 地址消息
class Address {
    var street: String = ""
    var city: String = ""
    var province: String = ""
    var zipCode: String = ""
    
    /// 序列化
    func serializedData() throws -> Data {
        var data = Data()
        
        // 序列化 street
        data.append(encodeString(fieldNumber: 1, value: street))
        
        // 序列化 city
        data.append(encodeString(fieldNumber: 2, value: city))
        
        // 序列化 province
        data.append(encodeString(fieldNumber: 3, value: province))
        
        // 序列化 zipCode
        data.append(encodeString(fieldNumber: 4, value: zipCode))
        
        return data
    }
    
    /// 反序列化
    convenience init(serializedData: Data) throws {
        self.init()
        var index = 0
        
        while index < serializedData.count {
            let (fieldNumber, wireType, bytesRead) = decodeTag(data: serializedData, index: index)
            index += bytesRead
            
            switch fieldNumber {
            case 1: // street
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    street = value
                    index += bytesRead
                }
            case 2: // city
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    city = value
                    index += bytesRead
                }
            case 3: // province
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    province = value
                    index += bytesRead
                }
            case 4: // zipCode
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    zipCode = value
                    index += bytesRead
                }
            default:
                index += skipField(data: serializedData, index: index, wireType: wireType)
            }
        }
    }
}

// API 请求消息
class APIRequest {
    enum RequestType: Int32 {
        case login = 1
        case register = 2
        case getData = 3
    }
    
    var type: RequestType = .getData
    var timestamp: Int64 = 0
    var loginParams: LoginParams? = nil
    var registerParams: RegisterParams? = nil
    
    /// 序列化
    func serializedData() throws -> Data {
        var data = Data()
        
        // 序列化 type
        data.append(encodeVarint(fieldNumber: 1, wireType: 0, value: UInt64(type.rawValue)))
        
        // 序列化 timestamp
        data.append(encodeVarint(fieldNumber: 2, wireType: 0, value: UInt64(timestamp)))
        
        // 序列化 loginParams
        if let loginParams = loginParams {
            let loginData = try loginParams.serializedData()
            data.append(encodeMessage(fieldNumber: 3, value: loginData))
        }
        
        // 序列化 registerParams
        if let registerParams = registerParams {
            let registerData = try registerParams.serializedData()
            data.append(encodeMessage(fieldNumber: 4, value: registerData))
        }
        
        return data
    }
    
    /// 反序列化
    convenience init(serializedData: Data) throws {
        self.init()
        var index = 0
        
        while index < serializedData.count {
            let (fieldNumber, wireType, bytesRead) = decodeTag(data: serializedData, index: index)
            index += bytesRead
            
            switch fieldNumber {
            case 1: // type
                if wireType == 0 {
                    let (value, bytesRead) = decodeVarint(data: serializedData, index: index)
                    if let type = RequestType(rawValue: Int32(value)) {
                        self.type = type
                    }
                    index += bytesRead
                }
            case 2: // timestamp
                if wireType == 0 {
                    let (value, bytesRead) = decodeVarint(data: serializedData, index: index)
                    timestamp = Int64(value)
                    index += bytesRead
                }
            case 3: // loginParams
                if wireType == 2 {
                    let (length, bytesRead) = decodeVarint(data: serializedData, index: index)
                    index += bytesRead
                    let loginData = serializedData.subdata(in: index..<index+Int(length))
                    loginParams = try LoginParams(serializedData: loginData)
                    index += Int(length)
                }
            case 4: // registerParams
                if wireType == 2 {
                    let (length, bytesRead) = decodeVarint(data: serializedData, index: index)
                    index += bytesRead
                    let registerData = serializedData.subdata(in: index..<index+Int(length))
                    registerParams = try RegisterParams(serializedData: registerData)
                    index += Int(length)
                }
            default:
                index += skipField(data: serializedData, index: index, wireType: wireType)
            }
        }
    }
}

// 登录参数
class LoginParams {
    var username: String = ""
    var password: String = ""
    
    /// 序列化
    func serializedData() throws -> Data {
        var data = Data()
        
        // 序列化 username
        data.append(encodeString(fieldNumber: 1, value: username))
        
        // 序列化 password
        data.append(encodeString(fieldNumber: 2, value: password))
        
        return data
    }
    
    /// 反序列化
    convenience init(serializedData: Data) throws {
        self.init()
        var index = 0
        
        while index < serializedData.count {
            let (fieldNumber, wireType, bytesRead) = decodeTag(data: serializedData, index: index)
            index += bytesRead
            
            switch fieldNumber {
            case 1: // username
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    username = value
                    index += bytesRead
                }
            case 2: // password
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    password = value
                    index += bytesRead
                }
            default:
                index += skipField(data: serializedData, index: index, wireType: wireType)
            }
        }
    }
}

// 注册参数
class RegisterParams {
    var username: String = ""
    var password: String = ""
    var email: String = ""
    
    /// 序列化
    func serializedData() throws -> Data {
        var data = Data()
        
        // 序列化 username
        data.append(encodeString(fieldNumber: 1, value: username))
        
        // 序列化 password
        data.append(encodeString(fieldNumber: 2, value: password))
        
        // 序列化 email
        data.append(encodeString(fieldNumber: 3, value: email))
        
        return data
    }
    
    /// 反序列化
    convenience init(serializedData: Data) throws {
        self.init()
        var index = 0
        
        while index < serializedData.count {
            let (fieldNumber, wireType, bytesRead) = decodeTag(data: serializedData, index: index)
            index += bytesRead
            
            switch fieldNumber {
            case 1: // username
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    username = value
                    index += bytesRead
                }
            case 2: // password
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    password = value
                    index += bytesRead
                }
            case 3: // email
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    email = value
                    index += bytesRead
                }
            default:
                index += skipField(data: serializedData, index: index, wireType: wireType)
            }
        }
    }
}

// API 响应消息
class APIResponse {
    var code: Int32 = 0
    var message: String = ""
    var userInfo: UserInfo = UserInfo()
    
    /// 序列化
    func serializedData() throws -> Data {
        var data = Data()
        
        // 序列化 code
        data.append(encodeVarint(fieldNumber: 1, wireType: 0, value: UInt64(code)))
        
        // 序列化 message
        data.append(encodeString(fieldNumber: 2, value: message))
        
        // 序列化 userInfo
        let userInfoData = try userInfo.serializedData()
        data.append(encodeMessage(fieldNumber: 3, value: userInfoData))
        
        return data
    }
    
    /// 反序列化
    convenience init(serializedData: Data) throws {
        self.init()
        var index = 0
        
        while index < serializedData.count {
            let (fieldNumber, wireType, bytesRead) = decodeTag(data: serializedData, index: index)
            index += bytesRead
            
            switch fieldNumber {
            case 1: // code
                if wireType == 0 {
                    let (value, bytesRead) = decodeVarint(data: serializedData, index: index)
                    code = Int32(value)
                    index += bytesRead
                }
            case 2: // message
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    message = value
                    index += bytesRead
                }
            case 3: // userInfo
                if wireType == 2 {
                    let (length, bytesRead) = decodeVarint(data: serializedData, index: index)
                    index += bytesRead
                    let userInfoData = serializedData.subdata(in: index..<index+Int(length))
                    userInfo = try UserInfo(serializedData: userInfoData)
                    index += Int(length)
                }
            default:
                index += skipField(data: serializedData, index: index, wireType: wireType)
            }
        }
    }
}

// 用户信息
class UserInfo {
    var id: Int32 = 0
    var username: String = ""
    var nickname: String = ""
    var avatar: String = ""
    
    /// 序列化
    func serializedData() throws -> Data {
        var data = Data()
        
        // 序列化 id
        data.append(encodeVarint(fieldNumber: 1, wireType: 0, value: UInt64(id)))
        
        // 序列化 username
        data.append(encodeString(fieldNumber: 2, value: username))
        
        // 序列化 nickname
        data.append(encodeString(fieldNumber: 3, value: nickname))
        
        // 序列化 avatar
        data.append(encodeString(fieldNumber: 4, value: avatar))
        
        return data
    }
    
    /// 反序列化
    convenience init(serializedData: Data) throws {
        self.init()
        var index = 0
        
        while index < serializedData.count {
            let (fieldNumber, wireType, bytesRead) = decodeTag(data: serializedData, index: index)
            index += bytesRead
            
            switch fieldNumber {
            case 1: // id
                if wireType == 0 {
                    let (value, bytesRead) = decodeVarint(data: serializedData, index: index)
                    id = Int32(value)
                    index += bytesRead
                }
            case 2: // username
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    username = value
                    index += bytesRead
                }
            case 3: // nickname
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    nickname = value
                    index += bytesRead
                }
            case 4: // avatar
                if wireType == 2 {
                    let (value, bytesRead) = decodeString(data: serializedData, index: index)
                    avatar = value
                    index += bytesRead
                }
            default:
                index += skipField(data: serializedData, index: index, wireType: wireType)
            }
        }
    }
}

// Protocol Buffer 编码/解码工具函数

/// 编码 varint
func encodeVarint(fieldNumber: Int, wireType: Int, value: UInt64) -> Data {
    var data = Data()
    // 编码 tag
    let tag = UInt64((fieldNumber << 3) | wireType)
    data.append(encodeVarintValue(tag))
    // 编码 value
    data.append(encodeVarintValue(value))
    return data
}

/// 编码 varint 值
func encodeVarintValue(_ value: UInt64) -> Data {
    var data = Data()
    var v = value
    while v >= 0x80 {
        data.append(UInt8(v & 0x7F | 0x80))
        v >>= 7
    }
    data.append(UInt8(v))
    return data
}

/// 编码字符串
func encodeString(fieldNumber: Int, value: String) -> Data {
    var data = Data()
    // 编码 tag
    let tag = UInt64((fieldNumber << 3) | 2) // wireType 2 表示长度前缀
    data.append(encodeVarintValue(tag))
    // 编码长度
    data.append(encodeVarintValue(UInt64(value.utf8.count)))
    // 编码内容
    data.append(value.data(using: .utf8)!)  // 强制解包，实际项目中应该处理
    return data
}

/// 编码布尔值
func encodeBool(fieldNumber: Int, value: Bool) -> Data {
    return encodeVarint(fieldNumber: fieldNumber, wireType: 0, value: value ? 1 : 0)
}

/// 编码 double
func encodeDouble(fieldNumber: Int, value: Double) -> Data {
    var data = Data()
    // 编码 tag
    let tag = UInt64((fieldNumber << 3) | 1) // wireType 1 表示 64 位
    data.append(encodeVarintValue(tag))
    // 编码值
    let bytes = withUnsafeBytes(of: value.bitPattern) { Array($0) }
    data.append(contentsOf: bytes)
    return data
}

/// 编码嵌套消息
func encodeMessage(fieldNumber: Int, value: Data) -> Data {
    var data = Data()
    // 编码 tag
    let tag = UInt64((fieldNumber << 3) | 2) // wireType 2 表示长度前缀
    data.append(encodeVarintValue(tag))
    // 编码长度
    data.append(encodeVarintValue(UInt64(value.count)))
    // 编码内容
    data.append(value)
    return data
}

/// 解码 tag
func decodeTag(data: Data, index: Int) -> (fieldNumber: Int, wireType: Int, bytesRead: Int) {
    var index = index
    var tag: UInt64 = 0
    var shift: UInt64 = 0
    var bytesRead = 0
    
    while index < data.count {
        let byte = data[index]
        tag |= UInt64(byte & 0x7F) << shift
        index += 1
        bytesRead += 1
        if byte < 0x80 {
            break
        }
        shift += 7
    }
    
    let fieldNumber = Int(tag >> 3)
    let wireType = Int(tag & 0x7)
    return (fieldNumber, wireType, bytesRead)
}

/// 解码 varint
func decodeVarint(data: Data, index: Int) -> (value: UInt64, bytesRead: Int) {
    var index = index
    var value: UInt64 = 0
    var shift: UInt64 = 0
    var bytesRead = 0
    
    while index < data.count {
        let byte = data[index]
        value |= UInt64(byte & 0x7F) << shift
        index += 1
        bytesRead += 1
        if byte < 0x80 {
            break
        }
        shift += 7
    }
    
    return (value, bytesRead)
}

/// 解码字符串
func decodeString(data: Data, index: Int) -> (value: String, bytesRead: Int) {
    let (length, lengthBytes) = decodeVarint(data: data, index: index)
    let contentStart = index + lengthBytes
    let contentEnd = contentStart + Int(length)
    let contentData = data.subdata(in: contentStart..<contentEnd)
    let string = String(data: contentData, encoding: .utf8) ?? ""
    return (string, lengthBytes + Int(length))
}

/// 解码 double
func decodeDouble(data: Data, index: Int) -> Double {
    let bytes = data.subdata(in: index..<index+8)
    let value = bytes.withUnsafeBytes { $0.load(as: UInt64.self) }
    return Double(bitPattern: value)
}

/// 跳过字段
func skipField(data: Data, index: Int, wireType: Int) -> Int {
    var index = index
    
    switch wireType {
    case 0: // varint
        while index < data.count && data[index] >= 0x80 {
            index += 1
        }
        index += 1
    case 1: // 64-bit
        index += 8
    case 2: // length-delimited
        let (length, lengthBytes) = decodeVarint(data: data, index: index)
        index += lengthBytes + Int(length)
    case 3, 4: // start group, end group (deprecated)
        fatalError("Group wire type is deprecated")
    case 5: // 32-bit
        index += 4
    default:
        fatalError("Invalid wire type")
    }
    
    return index - index
}
