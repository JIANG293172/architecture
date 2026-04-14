# iOS开发高频词汇

## 一、Swift语言基础 (Swift Fundamentals)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| 可选类型 | Optional | /ˈɒpʃənl/ | Swift uses optionals to handle nil values. |
| 闭包 | Closure | /ˈkləʊʒər/ | We use closures for callbacks. |
| 协议 | Protocol | /ˈprəʊtəkɒl/ | UIViewController is a protocol. |
| 扩展 | Extension | /ɪkˈstɛnʃən/ | We can extend existing types. |
| 泛型 | Generic | /dʒɪˈnɛrɪk/ | Generics allow type-safe code. |
| 属性 | Property | /ˈprɒpəti/ | Each property has a type. |
| 方法 | Method | /ˈmɛθəd/ | Call this method when ready. |
| 初始化 | Initialization | /ɪˌnɪʃəlaɪˈzeɪʃən/ | The init method sets up the object. |
| 析构器 | Deinitializer | /diːɪˈnɪʃəlaɪzər/ | Deinit is called when object is deallocated. |
| 类型转换 | Type Casting | /taɪp ˈkɑːstɪŋ/ | Use 'as' for type casting. |
| 继承 | Inheritance | /ɪnˈhɛrɪtəns/ | Classes support single inheritance. |
| 多态 | Polymorphism | /ˌpɒlɪˈmɔːfɪzəm/ | Polymorphism allows different forms. |
| 枚举 | Enum/Enumeration | /ɪˈnjuːməreɪʃən/ | Use enums for related values. |
| 结构体 | Struct | /strʌkt/ | Structs are value types. |
| 类 | Class | /klɑːs/ | Classes are reference types. |
| 实例 | Instance | /ˈɪnstəns/ | Create an instance of this class. |
| 对象 | Object | /ˈɒbdʒɪkt/ | Everything is an object in Swift. |
| 协议组合 | Protocol Composition | /ˈprəʊtəkɒl ˌkɒmpəˈzɪʃən/ | Use protocol composition for multiple protocols. |

---

## 二、iOS框架 (iOS Frameworks)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| UIKit | UI框架 | /juː-aɪ-kɪt/ | UIKit provides the core iOS UI. |
| SwiftUI | Swift UI框架 | /swɪft-juː-aɪ/ | SwiftUI is a declarative UI framework. |
| 视图控制器 | View Controller | /vjuː kənˈtrəʊlər/ | Each screen has a view controller. |
| 导航控制器 | Navigation Controller | /ˌnævɪˈɡeɪʃən kənˈtrəʊlər/ | Use navigation controller for stack navigation. |
| 表格视图 | Table View | /ˈteɪbl vjuː/ | UITableView displays lists. |
| 集合视图 | Collection View | /kəˈlɛkʃən vjuː/ | UICollectionView for grid layouts. |
| 视图生命周期 | View Lifecycle | /vjuː ˈlaɪfsaɪkl/ | Understanding view lifecycle is crucial. |
| 应用生命周期 | App Lifecycle | /æp ˈlaɪfsaɪkl/ | App lifecycle has multiple states. |
| 场景 | Scene | /siːn/ | Scene manages the UI lifecycle. |
| 窗口 | Window | /ˈwɪndəʊ/ | The window is the root container. |
| 视图 | View | /vjuː/ | Add subviews to the main view. |
| 层 | Layer | /ˈleɪər/ | Use CALayer for custom graphics. |
| 约束 | Constraint | /kənˈstreɪnt/ | Auto Layout uses constraints. |
| 安全区域 | Safe Area | /seɪf ˈeərɪə/ | Respect the safe area insets. |

| 手势识别器 | Gesture Recognizer | /ˈdʒɛstʃər ˈrɛkəɡnaɪzər/ | Add tap gesture recognizer. |
| 动画 | Animation | /ˌænɪˈmeɪʃən/ | Use animations for smooth transitions. |
| 绘图 | Drawing | /ˈdrɔːɪŋ/ | Override draw(_:) for custom drawing. |
| 图像 | Image | /ˈɪmɪdʒ/ | Load images with UIImage. |
| 颜色 | Color | /ˈkʌlər/ | Set the background color. |
| 字体 | Font | /fɒnt/ | Use system font for text. |

---

## 三、Auto Layout 与 UI (4.10)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| 自动布局 | Auto Layout | /ˈɔːtəʊ ˈleɪaʊt/ | Auto Layout creates adaptive UIs. |
| 约束 | Constraint | /kənˈstreɪnt/ | Add a leading constraint. |
| 堆栈视图 | Stack View | /stæk vjuː/ | UIStackView arranges views in a line. |
| 布局选项 | Layout Option | /ˈleɪaʊt ˈɒpʃən/ | Set content hugging and resistance. |
| 内容拥抱优先级 | Content Hugging Priority | /ˈkɒntɛnt ˈhʌɡɪŋ praɪˈɒrɪti/ | Increase content hugging priority. |
| 抗压缩优先级 | Compression Resistance | /kəmˈprɛʃən rɪˈzɪstəns/ | Set compression resistance priority. |
| 间距 | Spacing | /ˈspeɪsɪŋ/ | Adjust spacing between views. |
| 边距 | Margin | /ˈmɑːrdʒɪn/ | Use margins for consistent layout. |
| 内边距 | Padding | /ˈpædɪŋ/ | Add padding inside the view. |
| 尺寸 | Size | /saɪz/ | Set the size of the view. |
| 位置 | Position | /pəˈzɪʃən/ | Change the position of the view. |
| 对齐 | Alignment | /əˈlaɪnmənt/ | Use alignment for proper layout. |
| 等宽 | Equal Width | /ˈiːkwəl wɪdθ/ | Make views equal width. |
| 等高 | Equal Height | /ˈiːkwəl haɪt/ | Set equal height constraints. |
| 宽高比 | Aspect Ratio | /ˈæspɛkt ˈreɪʃiəʊ/ | Maintain aspect ratio of images. |
| 相对布局 | Relative Layout | /ˈrɛlətɪv ˈleɪaʊt/ | Use relative positioning. |
| 居中对齐 | Center Alignment | /ˈsɛntər əˈlaɪnmənt/ | Center the view horizontally. |
| 优先级 | Priority | /praɪˈɒrɪti/ | Set constraint priority. |
| 必要约束 | Required Constraint | /rɪˈkwaɪərd kənˈstreɪnt/ | Required constraints must be satisfied. |
| 可选约束 | Optional Constraint | /ˈɒpʃənl kənˈstreɪnt/ | Optional constraints can be broken. |

---

## 四、网络编程 (Networking)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| 网络请求 | Network Request | /ˈnɛtwɜːk rɪˈkwɛst/ | Make a network request to the API. |
| API调用 | API Call | /eɪ-piː-aɪ kɔːl/ | This API call returns user data. |
| 端点 | Endpoint | /ˈɛndpɔɪnt/ | The endpoint URL is /api/users. |
| 请求方法 | HTTP Method | /eɪʧ-tiː-piː ˈmɛθəd/ | Use GET for fetching data. |
| 请求头 | Request Header | /rɪˈkwɛst ˈhɛdər/ | Add headers to the request. |
| 请求体 | Request Body | /rɪˈkwɛst ˈbɒdi/ | Send data in the request body. |
| 响应 | Response | /rɪˈspɒns/ | Parse the JSON response. |
| 状态码 | Status Code | /ˈsteɪtəs kəʊd/ | 200 means success. |
| 授权 | Authorization | /ˌɔːθəraɪˈzeɪʃən/ | Add authorization header. |
| 身份验证 | Authentication | /ɔːˌθɛntɪˈkeɪʃən/ | Implement token-based authentication. |
| 令牌 | Token | /ˈtəʊkən/ | Store the access token securely. |
| 超时 | Timeout | /ˈtaɪmaʊt/ | Set a reasonable timeout. |
| 缓存 | Cache | /kæʃ/ | Use cache to improve performance. |
| 解析 | Parsing | /ˈpɑːzɪŋ/ | Parse JSON data with Codable. |
| 序列化 | Serialization | /ˌsɪərɪəlaɪˈzeɪʃən/ | JSON serialization converts objects. |
| 反序列化 | Deserialization | /diːˌsɪərɪəlaɪˈzeɪʃən/ | Deserialize the response data. |
| 分页 | Pagination | /ˌpædʒɪˈneɪʃən/ | Implement pagination for large lists. |
| 重试 | Retry | /rɪˈtraɪ/ | Implement retry logic for failures. |
| 错误处理 | Error Handling | /ˈɛrə ˈhændlɪŋ/ | Proper error handling is essential. |
| 连接 | Connection | /kəˈnɛkʃən/ | Check network connection status. |

---

## 五、数据存储 (Data Persistence)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| 用户默认 | UserDefaults | /ˈjuːzə dɪˈfɔːlts/ | Store preferences in UserDefaults. |
| 文件存储 | File Storage | /faɪl ˈstɔːrɪdʒ/ | Save data to the documents directory. |
| 数据库 | Database | /ˈdeɪtəbeɪs/ | Core Data is Apple's database framework. |
| 核心数据 | Core Data | /kɔːr ˈdeɪtə/ | Use Core Data for complex data models. |
| 实体 | Entity | /ˈɛntɪti/ | An entity represents a database table. |
| 属性 | Attribute | /ˈætrɪbjuːt/ | Add attributes to the entity. |
| 关系 | Relationship | /rɪˈleɪʃənʃɪp/ | Set up relationships between entities. |
| 托管对象 | Managed Object | /ˈmænɪdʒd ˈɒbdʒɪkt/ | Work with managed objects in context. |
| 迁移 | Migration | /maɪˈɡreɪʃən/ | Handle model migration carefully. |
| 键值存储 | Key-Value Store | /kiː væljuː stɔːr/ | Use key-value store for simple data. |
| 钥匙串 | Keychain | /ˈkiːtʃeɪn/ | Store sensitive data in Keychain. |
| 安全存储 | Secure Storage | /sɪˈkjʊər ˈstɔːrɪdʒ/ | Use secure storage for tokens. |
| 归档 | Archiving | /ˈɑːkaɪvɪŋ/ | Use NSCoding for archiving objects. |
| 持久化 | Persistence | /pəˈsɪstəns/ | Data persistence is crucial for apps. |
| 沙盒 | Sandbox | /ˈsændbɒks/ | Each app has its own sandbox. |
| 文档目录 | Documents Directory | /ˈdɒkjʊmənts dɪˈrɛktəri/ | Save files to documents directory. |
| 缓存目录 | Caches Directory | /kæʃɪz dɪˈrɛktəri/ | Store temporary files in caches. |
| 临时目录 | Temporary Directory | /ˈtɛmpərəri dɪˈrɛktəri/ | Use temp directory for temp files. |

---

## 六、架构模式 (Architecture Patterns)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| 架构模式 | Architecture Pattern | /ˈɑːkɪtɛktʃər ˈpætən/ | Choose the right architecture pattern. |
| 模型 | Model | /ˈmɒdl/ | The model represents data. |
| 视图 | View | /vjuː/ | Views display the UI. |
| 视图模型 | ViewModel | /vjuː ˈmɒdl/ | ViewModel handles presentation logic. |
| 控制器 | Controller | /kənˈtrəʊlər/ | Controllers coordinate models and views. |
| 协调器 | Coordinator | /kəʊˈɔːdɪneɪtər/ | Use coordinator for navigation flow. |
| 依赖注入 | Dependency Injection | /dɪˈpɛndənsi ɪnˈdʒɛkʃən/ | DI makes code more testable. |
| 服务定位器 | Service Locator | /ˈsɜːvɪs ləʊˈkeɪtər/ | Service locator provides dependencies. |
| 单例 | Singleton | /ˈsɪŋɡltən/ | Use singleton for shared instances. |
| 工厂模式 | Factory Pattern | /ˈfæktəri ˈpætən/ | Factory pattern creates objects. |
| 观察者模式 | Observer Pattern | /əbˈzɜːvər ˈpætən/ | Use observer pattern for notifications. |
| 委托模式 | Delegate Pattern | /ˈdɛlɪɡət ˈpætən/ | Delegates handle callbacks. |
| 闭包回调 | Closure Callback | /ˈkləʊʒər ˈkɔːlbæk/ | Use closures for async callbacks. |
| 响应式编程 | Reactive Programming | /rɪˈæktɪv ˈprəʊɡræmɪŋ/ | Combine enables reactive programming. |
| 函数式编程 | Functional Programming | /ˈfʌŋkʃənl ˈprəʊɡræmɪŋ/ | Swift supports functional programming. |
| 面向协议编程 | Protocol-Oriented Programming | /ˈprəʊtəkɒl ˈɔːrɪəntɪd ˈprəʊɡræmɪŋ/ | POP is a Swift best practice. |
| 清洁架构 | Clean Architecture | /kliːn ˈɑːkɪtɛktʃər/ | Clean Architecture separates concerns. |
| 分层架构 | Layered Architecture | /ˈleɪərd ˈɑːkɪtɛktʃər/ | Layered architecture organizes code. |
| 微服务 | Microservices | /ˈmaɪkrəʊˌsɜːvɪsɪz/ | Break monolith into microservices. |
| 松耦合 | Loose Coupling | /luːs ˈkʌplɪŋ/ | Aim for loose coupling between modules. |

---

## 七、并发与多线程 (Concurrency)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| 异步编程 | Asynchronous Programming | /eɪˈsɪŋkrənəs ˈprəʊɡræmɪŋ/ | Use async for asynchronous tasks. |
| 同步编程 | Synchronous Programming | /ˈsɪŋkrənəs ˈprəʊɡræmɪŋ/ | Synchronous code blocks the thread. |
| 主线程 | Main Thread | /meɪn θrɛd/ | Update UI on the main thread. |
| 后台线程 | Background Thread | /ˈbækɡraʊnd θrɛd/ | Do heavy work on background thread. |
| 队列 | Queue | /kjuː/ | Dispatch to the main queue. |
| 调度 | Dispatch | /dɪˈspætʃ/ | Use dispatch for concurrency. |
| 任务 | Task | /tɑːsk/ | Create a task for async work. |
| 线程安全 | Thread Safety | /θrɛd ˈseɪfti/ | Ensure thread safety for shared data. |
| 竞态条件 | Race Condition | /reɪs kənˈdɪʃən/ | Avoid race conditions. |
| 死锁 | Deadlock | /ˈdɛdlɒk/ | Prevent deadlocks in concurrent code. |
| 锁 | Lock | /lɒk/ | Use lock to protect shared resources. |
| 信号量 | Semaphore | /ˈsɛməfɔːr/ | Use semaphore to limit concurrency. |
| 组调度 | Dispatch Group | /dɪˈspætʃ ɡruːp/ | Use dispatch group to wait for tasks. |
| 执行器 | Executor | /ɪɡˈzɛkjʊtər/ | Executor manages task execution. |
| Actor | Actor | /ˈæktər/ | Actors provide thread-safe state. |
| @MainActor | @MainActor | /æt meɪn ˈæktər/ | @MainActor ensures UI updates on main. |
| async/await | async/await | /eɪˈsɪŋk/əwˈeɪt/ | Use async/await for cleaner async code. |
| 并行 | Parallel | /ˈpærəlɛl/ | Run tasks in parallel. |
| 串行 | Serial | /ˈsɪərɪəl/ | Serial queues execute one at a time. |
| 线程池 | Thread Pool | /θrɛd puːl/ | Thread pool manages worker threads. |

---

## 八、内存管理 (Memory Management)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| 自动引用计数 | ARC | /eɪ-ɑːr-siː/ | ARC automatically manages memory. |
| 强引用 | Strong Reference | /strɒŋ ˈrɛfərəns/ | Strong references keep objects alive. |
| 弱引用 | Weak Reference | /wiːk ˈrɛfərəns/ | Use weak to avoid retain cycles. |
| 无主引用 | Unowned Reference | /ʌnˈəʊnd ˈrɛfərəns/ | Use unowned for non-optional references. |
| 强引用循环 | Retain Cycle | /rɪˈteɪn ˈsaɪkl/ | Avoid retain cycles in closures. |
| 内存泄漏 | Memory Leak | /ˈmɛməri liːk/ | Check for memory leaks with Instruments. |
| 内存分配 | Memory Allocation | /ˈmɛməri ˌæləˈkeɪʃən/ | Track memory allocations in debug. |
| 释放 | Deallocation | /diːˌæləˈkeɪʃən/ | Memory is deallocated when not used. |
| 引用计数 | Reference Count | /ˈrɛfərəns kaʊnt/ | ARC tracks reference counts. |
| 循环引用 | Circular Reference | /ˈsɜːkjʊlər ˈrɛfərəns/ | Break circular references with weak. |
| 捕获列表 | Capture List | /ˈkæptʃər lɪst/ | Use capture list to avoid retain cycles. |
| 内存警告 | Memory Warning | /ˈmɛməri ˈwɔːnɪŋ/ | Handle didReceiveMemoryWarning. |
| 释放池 | Autorelease Pool | /ˈɔːtərɪˌliːs puːl/ | Use autorelease pool for batched releases. |
| 堆 | Heap | /hiːp/ | Objects are allocated on the heap. |
| 栈 | Stack | /stæk/ | Value types are allocated on the stack. |
| 拷贝 | Copy | /ˈkɒpi/ | Copy on assign for value types. |
| 共享 | Shared | /ʃeəd/ | Use shared instance for singletons. |
| 清理 | Cleanup | /ˈkliːnʌp/ | Perform cleanup in deinit. |
| 延迟加载 | Lazy Loading | /ˈleɪzi ˈləʊdɪŋ/ | Use lazy loading for expensive resources. |
| 资源管理 | Resource Management | /ˈriːsɔːrs ˈmænɪdʒmənt/ | Proper resource management prevents leaks. |

---

## 九、调试与测试 (Debugging & Testing)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| 断点 | Breakpoint | /ˈbreɪkpɔɪnt/ | Set a breakpoint to debug. |
| 调试器 | Debugger | /diːˈbʌɡər/ | Use Xcode debugger to step through code. |
| 逐步执行 | Step Over | /stɛp ˈəʊvər/ | Step over the current line. |
| 单步执行 | Step Into | /stɛp ˈɪntuː/ | Step into the function. |
| 跳出 | Step Out | /stɛp aʊt/ | Step out of the current function. |
| 变量监视 | Watch Variable | /wɒtʃ ˈveərɪəbl/ | Add a watch for the variable. |
| 调用栈 | Call Stack | /kɔːl stæk/ | Inspect the call stack. |
| 崩溃日志 | Crash Log | /kræʃ lɒɡ/ | Analyze crash logs. |
| 控制台 | Console | /ˈkɒnsəʊl/ | Check console for logs. |
| 输出日志 | Output Log | /ˈaʊtpʊt lɒɡ/ | Print output to console. |
| 断言 | Assertion | /əˈsɜːʃən/ | Use assertions to check invariants. |
| 单元测试 | Unit Test | /ˈjuːnɪt tɛst/ | Write unit tests for your code. |
| UI测试 | UI Test | /juː-aɪ tɛst/ | Use UI tests for end-to-end testing. |
| 集成测试 | Integration Test | /ˌɪntɪˈɡreɪʃən tɛst/ | Write integration tests for modules. |
| 测试驱动开发 | TDD | /tiː-diː-diː/ | TDD writes tests before code. |
| 行为驱动开发 | BDD | /biː-diː-diː/ | BDD focuses on behavior. |
| Mock对象 | Mock Object | /mɒk ˈɒbdʒɪkt/ | Use mocks for testing. |
| 测试覆盖 | Test Coverage | /tɛst ˈkʌvərɪdʒ/ | Measure test coverage. |
| 回归测试 | Regression Test | /rɪˈɡrɛʃən tɛst/ | Run regression tests before release. |
| 性能测试 | Performance Test | /pəˈfɔːməns tɛst/ | Run performance tests for speed. |

---

## 十、版本控制 (Version Control)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| 仓库 | Repository | /rɪˈpɒzɪtəri/ | Clone the repository. |
| 克隆 | Clone | /kləʊn/ | Clone the repo to your local machine. |
| 分支 | Branch | /brɑːntʃ/ | Create a new feature branch. |
| 提交 | Commit | /kəˈmɪt/ | Commit your changes with a message. |
| 推送 | Push | /pʊʃ/ | Push changes to remote. |
| 拉取 | Pull | /pʊl/ | Pull latest changes from remote. |
| 合并 | Merge | /mɜːdʒ/ | Merge the feature branch. |
| 变基 | Rebase | /riːˈbeɪs/ | Rebase your branch onto main. |
| 冲突 | Conflict | /ˈkɒnflɪkt/ | Resolve merge conflicts. |
| 拉取请求 | Pull Request | /pʊl rɪˈkwɛst/ | Open a pull request for review. |
| 代码审查 | Code Review | /kəʊd rɪˈvjuː/ | Request a code review. |
| 检出 | Checkout | /ˈtʃɛkaʊt/ | Checkout the main branch. |
| 暂存 | Stash | /stæʃ/ | Stash your changes temporarily. |
| 重置 | Reset | /rɪːˈsɛt/ | Reset to the previous commit. |
| 撤销 | Revert | /rɪˈvɜːt/ | Revert the last commit. |
| 状态 | Status | /ˈsteɪtəs/ | Check git status. |
| 差异 | Diff | /dɪf/ | Show the diff of changes. |
| 日志 | Log | /lɒɡ/ | View git log for history. |
| 标签 | Tag | /tæɡ/ | Tag the release version. |
| 忽略 | Ignore | /ɪɡˈnɔːr/ | Add files to .gitignore. |

---

## 十一、App发布与分发 (App Distribution)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| 应用商店 | App Store | /æp stɔːr/ | Publish the app on App Store. |
| TestFlight | TestFlight | /tɛst flaɪt/ | Use TestFlight for beta testing. |
| 企业分发 | Enterprise Distribution | /ˈɛntəpraɪz dɪˌstrɪˈbjuːʃən/ | Enterprise distribution for internal apps. |
| 打包 | Archive | /ˈɑːkaɪv/ | Archive the app for distribution. |
| 证书 | Certificate | /səˈtɪfɪkət/ | Manage signing certificates. |
| 描述文件 | Provisioning Profile | /prəˈvɪʒənɪŋ ˈprəʊfaɪl/ | Configure provisioning profile. |
| 签名 | Signing | /ˈsaɪnɪŋ/ | Sign the app before distribution. |
| 构建版本 | Build | /bɪld/ | Create a new build for testing. |
| 版本号 | Version Number | /ˈvɜːʃən ˈnʌmbər/ | Bump the version number. |
| 内部测试 | Internal Testing | /ɪnˈtɜːnl ˈtɛstɪŋ/ | Start with internal testing. |
| 外部测试 | External Testing | /ɪkˈstɜːnl ˈtɛstɪŋ/ | Move to external testing. |
| 提交审核 | Submit for Review | /səbˈmɪt fɔː rɪˈvjuː/ | Submit the app for review. |
| 审核状态 | Review Status | /rɪˈvjuː ˈsteɪtəs/ | Check the review status. |
| 拒绝 | Rejection | /rɪˈdʒɛkʃən/ | Address the app rejection. |
| 拒绝原因 | Rejection Reason | /rɪˈdʒɛkʃən ˈriːzn/ | Understand the rejection reason. |
| 上架 | Publish | /ˈpʌblɪʃ/ | Publish the approved app. |
| 更新 | Update | /ʌpˈdeɪt/ | Push an update to the app. |
| 灰度发布 | Staged Release | /steɪdʒd rɪˈliːs/ | Use staged release for gradual rollout. |
| 崩溃率 | Crash Rate | /kræʃ reɪt/ | Monitor the crash rate. |
| 用户评分 | User Rating | /ˈjuːzə ˈreɪtɪŋ/ | Track user ratings and reviews. |

---

## 十二、SwiftUI框架 (SwiftUI)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| 声明式UI | Declarative UI | /dɪˈklærətɪv juː-aɪ/ | SwiftUI uses declarative UI. |
| 状态 | State | /steɪt/ | Use @State for local state. |
| 绑定 | Binding | /ˈbaɪndɪŋ/ | Use @Binding to pass state. |
| 可观察对象 | ObservableObject | /ˌɒbzəˈveɪbl ˈɒbdʒɪkt/ | Create an observable object. |
| 环境对象 | EnvironmentObject | /ɪnˈvaɪərənmənt ˈɒbdʒɪkt/ | Share state across the view tree. |
| 视图构建器 | ViewBuilder | /vjuː ˈbɪldər/ | Use ViewBuilder for complex views. |
| 属性包装器 | Property Wrapper | /ˈprɒpəti ˈræpər/ | @State, @Binding are property wrappers. |
| 修饰器 | Modifier | /ˈmɒdɪfaɪər/ | Apply modifiers to views. |
| 身体 | Body | /ˈbɒdi/ | The view's body property. |
| 惰性视图 | Lazy View | /ˈleɪzi vjuː/ | Use LazyVStack for performance. |
| 导航链接 | NavigationLink | /ˌnævɪˈɡeɪʃən lɪŋk/ | Navigate with NavigationLink. |
| 列表 | List | /lɪst/ | Use List for scrollable content. |
| 表单 | Form | /fɔːm/ | Use Form for settings screens. |
| 警报 | Alert | /əˈlɜːt/ | Show alerts to users. |
| 弹窗 | Sheet | /ʃiːt/ | Present a sheet modal. |
| 全屏弹窗 | Full Screen Cover | /fʊl skriːn ˈkʌvər/ | Use full screen cover for modals. |
| 偏好设置 | Preference | /ˈprɛfərəns/ | Set view preferences. |
| 转换动画 | Transition | /trænˈzɪʃən/ | Add transitions between views. |
| 动画 | Animation | /ˌænɪˈmeɪʃən/ | Apply animations to state changes. |
| 组合 | Composition | /ˌkɒmpəˈzɪʃən/ | Build views through composition. |

---

## 十三、Combine框架 (Combine)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| 发布者 | Publisher | /pʌblɪˈʃər/ | Publishers emit values over time. |
| 订阅者 | Subscriber | /səbˈskraɪbər/ | Subscribers receive values. |
| 订阅 | Subscription | /səbˈskrɪpʃən/ | Manage the subscription. |
| 操作符 | Operator | /ˈɒpəreɪtər/ | Use operators to transform streams. |
| 主题 | Subject | /ˈsʌbdʒɪkt/ | Use CurrentValueSubject for state. |
| 地图 | Map | /mæp/ | Map transforms emitted values. |
| 过滤 | Filter | /ˈfɪltər/ | Filter unwanted values. |
| 合并 | Merge | /mɜːdʒ/ | Merge multiple publishers. |
| 组合 | Combine | /kəmˈbaɪn/ | Combine multiple streams. |
| 扁平映射 | FlatMap | /flæt mæp/ | FlatMap flattens nested publishers. |
| 移除重复 | Remove Duplicates | /rɪˈmuːv ˈdjuːplɪkɪts/ | Remove duplicate values. |
| 收集 | Collect | /kəˈlɛkt/ | Collect values into an array. |
| 错误处理 | Error Handling | /ˈɛrə ˈhændlɪŋ/ | Handle errors in the pipeline. |
| 捕获失败 | Catch | /kætʃ/ | Catch and handle errors. |
| 替代 | Replace | /rɪˈpleɪs/ | Replace nil with default value. |
| 扫描 | Scan | /skæn/ | Scan accumulates values. |
| 节流 | Throttle | /ˈθrɒtl/ | Throttle rapid events. |
| 防抖 | Debounce | /diːˈbaʊns/ | Debounce user input. |
| 调度器 | Scheduler | /ˈʃɛdjuːlər/ | Receive on main scheduler. |
| 存储 | Store | /stɔːr/ | Store the subscription. |

---

## 十四、GitHub与协作 (GitHub & Collaboration)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| 问题 | Issue | /ˈɪʃuː/ | Open an issue for bugs. |
| 里程碑 | Milestone | /ˈmaɪlstəʊn/ | Set a milestone for release. |
| 标签 | Label | /ˈleɪbl/ | Add labels to issues. |
| 指派 | Assign | /əˈsaɪn/ | Assign the issue to a team member. |
| 负责人 | Assignee | /əˈsaɪniː/ | The assignee is responsible. |
| 项目 | Project | /ˈprɒdʒɛkt/ | Track progress on project board. |
| 看板 | Kanban | /kɑːnˈbɑːn/ | Use kanban for agile workflow. |
| 维基 | Wiki | /ˈwɪki/ | Document in the wiki. |
| README | README | /ˈrɛdmiː/ | Write a clear README. |
| 贡献 | Contribute | /kənˈtrɪbjuːt/ | Contribute to open source. |
| Fork | Fork | /fɔːk/ | Fork the repository. |
| 审阅者 | Reviewer | /rɪˈvjuːər/ | Request a reviewer. |
| 批准 | Approve | /əˈpruːv/ | Approve the pull request. |
| 请求变更 | Request Changes | /rɪˈkwɛst ˈtʃeɪndʒɪz/ | Request changes in PR. |
| 合并 | Merge | /mɒdʒ/ | Merge approved PRs. |
| Squash | Squash | /skwɒʃ/ | Squash commits before merge. |
| Cherry-pick | Cherry-pick | /ˈtʃɛri pɪk/ | Cherry-pick specific commits. |
| 保护分支 | Protected Branch | /prəˈtɛktɪd brɑːntʃ/ | Main is a protected branch. |
| Actions | Actions | /ˈækʃənz/ | Use GitHub Actions for CI/CD. |
| 工作流 | Workflow | /ˈwɜːkfləʊ/ | Automate workflow with Actions. |

---

## 十五、敏捷开发 (Agile Development)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| 冲刺 | Sprint | /sprɪnt/ | Complete tasks within the sprint. |
| 产品待办列表 | Product Backlog | /ˈprɒdʌkt ˈbæklɒɡ/ | Prioritize the product backlog. |
| 冲刺待办列表 | Sprint Backlog | /sprɪnt ˈbæklɒɡ/ | Items in the sprint backlog. |
| 故事点 | Story Point | /ˈstɔːri pɔɪnt/ | Estimate with story points. |
| 燃尽图 | Burndown Chart | /bɜːndaʊn tʃɑːt/ | Track progress with burndown chart. |
| 每日站会 | Daily Standup | /ˈdeɪli ˈstændʌp/ | Attend the daily standup meeting. |
| 回顾会议 | Retrospective | /ˌrɛtrəʊˈspɛktɪv/ | Hold a retrospective after sprint. |
| 计划会议 | Planning Meeting | /ˈplænɪŋ ˈmiːtɪŋ/ | Conduct sprint planning meeting. |
| 评审会议 | Review Meeting | /rɪˈvjuː ˈmiːtɪŋ/ | Demo at sprint review meeting. |
| 完成定义 | Definition of Done | /ˌdɛfɪˈnɪʃən əv dʌn/ | Define clear done criteria. |
| 用户故事 | User Story | /ˈjuːzər ˈstɔːri/ | Write user stories for features. |
| 验收标准 | Acceptance Criteria | /əkˈsɛptəns kraɪˈtɪərɪə/ | Define acceptance criteria. |
| 看板 | Kanban Board | /kɑːnˈbɑːn bɔːrd/ | Visualize work on kanban board. |
| 泳道 | Swimlane | /ˈswɪmleɪn/ | Organize by team on swimlane. |
| 限制在制品 | Limit WIP | /ˈlɪmɪt wɪp/ | Limit work in progress. |
| 优先级 | Priority | /praɪˈɒrɪti/ | Prioritize backlog items. |
| 迭代 | Iteration | /ˌɪtəˈreɪʃən/ | Each iteration delivers value. |
| 增量 | Increment | /ˈɪnkrɪmənt/ | Each increment is potentially shippable. |
| 持续改进 | Continuous Improvement | /kənˈtɪnjuəs ɪmˈpruːvmənt/ | Agile emphasizes continuous improvement. |
| 跨功能团队 | Cross-functional Team | /krɒs ˈfʌŋkʃənl tiːm/ | Work in cross-functional teams. |

---

## 十六、职场常用词汇 (Workplace Vocabulary)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| 截止日期 | Deadline | /ˈdɛdlaɪn/ | Meet the project deadline. |
| 里程碑 | Milestone | /ˈmaɪlstəʊn/ | Achieve key milestones. |
| 优先级 | Priority | /praɪˈɒrɪti/ | Set task priorities. |
| 阻塞 | Blocked | /blɒkt/ | I'm blocked on this task. |
| 进度 | Progress | /ˈprəʊɡrəs/ | Make progress on the feature. |
| 延期 | Delay | /dɪˈleɪ/ | The release has been delayed. |
| 超时 | Overtime | /ˈəʊvətaɪm/ | Work overtime to meet deadline. |
| 委派 | Delegate | /ˈdɛlɪɡeɪt/ | Delegate tasks appropriately. |
| 协调 | Coordinate | /kəʊˈɔːdɪneɪt/ | Coordinate with other teams. |
| 同步 | Sync | /sɪŋk/ | Let's sync up later. |
| 升级 | Escalate | /ˈɛskəleɪt/ | Escalate critical issues. |
| 批准 | Approve | /əˈpruːv/ | Approve the proposal. |
| 拒绝 | Reject | /rɪˈdʒɛkt/ | Reject the suggestion. |
| 反馈 | Feedback | /ˈfiːdbæk/ | Provide constructive feedback. |
| 批准 | Approval | /əˈpruːvəl/ | Get manager approval. |
| 评审 | Review | /rɪˈvjuː/ | Request a code review. |
| 确认 | Confirm | /kənˈfɜːm/ | Confirm the meeting time. |
| 提醒 | Remind | /rɪˈmaɪnd/ | Remind me about the deadline. |
| 跟进 | Follow up | /ˈfɒləʊ ʌp/ | Follow up on the ticket. |
| 记录 | Document | /ˈdɒkjʊmənt/ | Document the decision. |

---

## 十七、iOS特定术语 (iOS Specific Terms)

| 中文 | English | 音标 | 例句 |
|------|---------|------|------|
| CocoaPods | CocoaPods | /ˈkəʊkəʊ pɒdz/ | Manage dependencies with CocoaPods. |
| Swift Package Manager | SPM | /swɪft ˈpækɪdʒ ˈmænɪdʒər/ | Use SPM for package management. |
| Cocoa Touch | Cocoa Touch | /ˈkəʊkəʊ tʌtʃ/ | Cocoa Touch is the iOS framework layer. |
| Interface Builder | IB | /ˈɪntəfeɪs ˈbɪldər/ | Design UI in Interface Builder. |
| Xcode | Xcode | /ˈɛksdaɪs/ | Use Xcode as the IDE. |
| Instruments | Instruments | /ɪnˈstrʊmənts/ | Profile with Instruments. |
| Simulator | Simulator | /ˈsɪmjʊleɪtər/ | Test on the iOS Simulator. |
| Playground | Playground | /ˈpleɪɡraʊnd/ | Try Swift in Playground. |
| Bridging Header | Bridging Header | /ˈbrɪdʒɪŋ ˈhɛdər/ | Set up bridging header for Obj-C. |
| Dynamic Framework | Dynamic Framework | /daɪˈnæmɪk ˈfreɪmwɜːk/ | Use dynamic frameworks. |
| Static Library | Static Library | /ˈstætɪk ˈlaɪbrəri/ | Link against static libraries. |
| Bitcode | Bitcode | /ˈbɪtkəʊd/ | Enable Bitcode for App Store. |
| Symbols | Symbols | /ˈsɪmblz/ | Strip symbols for release build. |
| dSYM | dSYM | /diː sɪm/ | dSYM contains debug symbols. |
| Entitlements | Entitlements | /ɪnˈtaɪtlmənts/ | Configure entitlements for capabilities. |
| Capabilities | Capabilities | /ˌkeɪpəˈbɪlɪtiz/ | Enable capabilities in Xcode. |
| Asset Catalog | Asset Catalog | /ˈæsɛt ˈkætəlɒɡ/ | Organize assets in asset catalog. |
| Launch Screen | Launch Screen | /lɔːntʃ skriːn/ | Configure launch screen storyboard. |
| Info.plist | Info.plist | /ɪnfoː piː lɪst/ | Configure app in Info.plist. |
| App Delegate | App Delegate | /æp ˈdɛlɪɡət/ | Implement the app delegate methods. |

---

## 十八、常用缩略语 (Common Abbreviations)

| 缩写 | 全称 | 中文 |
|------|------|------|
| API | Application Programming Interface | 应用程序接口 |
| ARC | Automatic Reference Counting | 自动引用计数 |
| CI | Continuous Integration | 持续集成 |
| CD | Continuous Deployment | 持续部署 |
| UI | User Interface | 用户界面 |
| UX | User Experience | 用户体验 |
| MVC | Model-View-Controller | 模型-视图-控制器 |
| MVVM | Model-View-ViewModel | 模型-视图-视图模型 |
| TDD | Test-Driven Development | 测试驱动开发 |
| BDD | Behavior-Driven Development | 行为驱动开发 |
| OOP | Object-Oriented Programming | 面向对象编程 |
| POP | Protocol-Oriented Programming | 协议导向编程 |
| IDE | Integrated Development Environment | 集成开发环境 |
| PR | Pull Request | 拉取请求 |
| MR | Merge Request | 合并请求 |
| CRUD | Create, Read, Update, Delete | 增删改查 |
| REST | Representational State Transfer | REST API |
| JSON | JavaScript Object Notation | JSON数据格式 |
| XML | Extensible Markup Language | XML标记语言 |
| SDK | Software Development Kit | 软件开发包 |
| ABI | Application Binary Interface | 应用程序二进制接口 |
| UIKit | User Interface Kit | UI框架 |
| SwiftUI | Swift User Interface | Swift UI框架 |
| SPM | Swift Package Manager | Swift包管理器 |
| Pod | CocoaPods Dependency | CocoaPods依赖 |
| IPA | iOS App Store Package | iOS安装包 |
| ATS | App Transport Security | 应用传输安全 |
| KVO | Key-Value Observing | 键值观察 |
| GCD | Grand Central Dispatch | 中央调度 |
| Combine | Apple's reactive framework | 苹果响应式框架 |
| Core Data | Apple's persistence framework | 苹果持久化框架 |

---

*建议每天背诵20个单词，结合例句记忆，2周内可完成核心词汇学习。*
