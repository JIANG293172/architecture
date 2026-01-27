//
//  Demo1ViewController.swift
//  SwiftUI10
//
//  Created by CQCA202121101_2 on 2026/1/22.
//

import UIKit
import MetalKit
import Metal
// Demo 1 ViewController - Metal图表绘制示例
class MetalViewController: UIViewController {
    
    // MARK: - 时间范围枚举
    enum TimeRange: String, CaseIterable {
        case sevenDays = "7天"
        case oneMonth = "1个月"
        case oneYear = "1年"
    }
    
    // MARK: - Metal相关属性
    private var metalView: MTKView! // Metal渲染视图
    private var device: MTLDevice! // Metal设备
    private var commandQueue: MTLCommandQueue! // 命令队列
    private var pipelineState: MTLRenderPipelineState! // 渲染管线状态
    private var vertexBuffer: MTLBuffer! // 顶点缓冲区
    private var indexBuffer: MTLBuffer! // 索引缓冲区
    private var uniformBuffer: MTLBuffer! //  uniforms缓冲区
    
    // MARK: - 数据相关属性
    private var currentTimeRange: TimeRange = .sevenDays
    private var fuelConsumptionData: [Float] = [] // 油耗数据
    private var mileageData: [Float] = [] // 里程数据
    private var timeLabels: [String] = [] // 时间标签
    
    // MARK: - UI相关属性
    private var segmentedControl: UISegmentedControl! // 时间范围选择器
    private var chartTypeSegmentedControl: UISegmentedControl! // 图表类型选择器
    private var chartType: Int = 0 // 0: 折线图(油耗), 1: 柱状图(里程)
    
    // MARK: - 生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Demo 1: Metal高性能图表"
        view.backgroundColor = .white
        
        setupUI()
        setupMetal()
        generateData(for: currentTimeRange)
    }
    // 在generateData方法中使用异步线程
    private func generateData(for timeRange: TimeRange) {
        // 计算天数
        var days: Int
        switch timeRange {
        case .sevenDays:
            days = 7
        case .oneMonth:
            days = 30
        case .oneYear:
            days = 365
        }
        
        // 在后台线程生成数据和计算顶点
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // 1. 生成数据
            let fuelConsumptionData = (0..<days).map { _ in 5.0 + Float.random(in: 0..<10.0) }
            let mileageData = (0..<days).map { _ in 10.0 + Float.random(in: 0..<90.0) }
            
            // 2. 生成时间标签
            var timeLabels: [String] = []
            for i in 0..<days {
                switch timeRange {
                case .sevenDays:
                    timeLabels.append("Day \(i+1)")
                case .oneMonth:
                    timeLabels.append("Day \(i+1)")
                case .oneYear:
                    timeLabels.append("Month \(i/30 + 1)")
                }
            }
            
            // 3. 存储数据
            self.fuelConsumptionData = fuelConsumptionData
            self.mileageData = mileageData
            self.timeLabels = timeLabels
            
            // 4. 回到主线程更新UI和Metal缓冲区
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.updateVertexData()
                self.updateUniforms()
                self.metalView.setNeedsDisplay()
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 视图布局变化时重新绘制，包括重新计算顶点数据
        updateVertexData()
        updateUniforms()
        metalView.setNeedsDisplay()
    }
    
    // MARK: - UI设置
    private func setupUI() {
        // 创建时间范围选择器
        let timeRangeTitles = TimeRange.allCases.map { $0.rawValue }
        segmentedControl = UISegmentedControl(items: timeRangeTitles)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(timeRangeChanged), for: .valueChanged)
        
        // 创建图表类型选择器
        chartTypeSegmentedControl = UISegmentedControl(items: ["油耗折线图", "里程柱状图"])
        chartTypeSegmentedControl.selectedSegmentIndex = 0
        chartTypeSegmentedControl.addTarget(self, action: #selector(chartTypeChanged), for: .valueChanged)
        
        // 添加到视图
        view.addSubview(segmentedControl)
        view.addSubview(chartTypeSegmentedControl)
        
        // 设置约束
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        chartTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            chartTypeSegmentedControl.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            chartTypeSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            chartTypeSegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
        
        // 创建Metal视图
        metalView = MTKView()
        metalView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(metalView)
        
        NSLayoutConstraint.activate([
            metalView.topAnchor.constraint(equalTo: chartTypeSegmentedControl.bottomAnchor, constant: 20),
            metalView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            metalView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            metalView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Metal设置
    private func setupMetal() {
        // 1. 获取Metal设备
        // 面试考点：Metal设备是与GPU通信的桥梁，每个iOS设备通常只有一个Metal设备
        device = MTLCreateSystemDefaultDevice()
        guard device != nil else {
            fatalError("Metal is not supported on this device")
        }
        
        // 2. 设置Metal视图
        metalView.device = device
        metalView.delegate = self
        metalView.clearColor = MTLClearColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        // 3. 创建命令队列
        // 面试考点：命令队列负责将渲染命令提交给GPU执行
        commandQueue = device.makeCommandQueue()
        
        // 4. 创建渲染管线
        // 面试考点：渲染管线定义了从顶点数据到最终像素的处理流程
        createRenderPipeline()
        
        // 5. 创建uniforms缓冲区
        // 面试考点：uniforms是对所有顶点都相同的数据，如变换矩阵、颜色等
        uniformBuffer = device.makeBuffer(length: MemoryLayout<Uniforms>.stride, options: [])
    }
    
    // MARK: - 创建渲染管线
    private func createRenderPipeline() {
        // 加载顶点着色器和片段着色器
        // 面试考点：Metal使用Metal Shading Language (MSL)编写着色器，类似于C++
        let library = device.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertexShader")
        let fragmentFunction = library?.makeFunction(name: "fragmentShader")
        
        // 创建渲染管线描述符
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // 创建渲染管线状态
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Failed to create pipeline state: \(error)")
        }
    }
    

    
    // MARK: - 更新顶点数据
    private func updateVertexData() {
        var vertices: [Vertex]
        var indices: [UInt16]
        
        if chartType == 0 {
            // 折线图
            (vertices, indices) = createLineChartVertices()
        } else {
            // 柱状图
            (vertices, indices) = createBarChartVertices()
        }
        
        // 创建顶点缓冲区
        // 面试考点：顶点缓冲区存储顶点数据，GPU可以直接访问，提高性能
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])
        
        // 创建索引缓冲区
        // 面试考点：索引缓冲区存储顶点索引，减少重复顶点数据，节省内存
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.stride, options: [])
    }
    
    // MARK: - 创建折线图顶点
    private func createLineChartVertices() -> ([Vertex], [UInt16]) {
        let data = fuelConsumptionData
        let count = data.count
        var vertices: [Vertex] = []
        var indices: [UInt16] = []
        
        // 计算数据范围
        let minValue = data.min() ?? 0
        let maxValue = data.max() ?? 1
        let valueRange = maxValue - minValue
        
        // 计算图表尺寸
        let chartWidth = Float(metalView.frame.width - 40)
        let chartHeight = Float(metalView.frame.height - 40)
        let xStep = chartWidth / Float(count - 1)
        
        // 创建顶点
        for (i, value) in data.enumerated() {
            let x = 20.0 + Float(i) * xStep
            let y = 20.0 + (value - minValue) / valueRange * chartHeight
            
            // 顶点坐标需要转换为Metal的标准化设备坐标 (-1 to 1)
            let normalizedX = (x / Float(metalView.frame.width)) * 2.0 - 1.0
            // 修复坐标系：Metal的y轴原点在左下角，而UIKit的y轴原点在左上角
            let normalizedY = (y / Float(metalView.frame.height)) * 2.0 - 1.0
            
            vertices.append(Vertex(position: SIMD2<Float>(normalizedX, normalizedY), color: SIMD4<Float>(0.0, 0.5, 1.0, 1.0)))
            
            if i > 0 {
                indices.append(UInt16(i-1))
                indices.append(UInt16(i))
            }
        }
        
        return (vertices, indices)
    }
    
    // MARK: - 创建柱状图顶点
    private func createBarChartVertices() -> ([Vertex], [UInt16]) {
        let data = mileageData
        let count = data.count
        var vertices: [Vertex] = []
        var indices: [UInt16] = []
        
        // 计算数据范围
        let minValue: Float = 0.0
        let maxValue = (data.max() ?? 1) * 1.1 // 留一些空间
        let valueRange = maxValue - minValue
        
        // 计算图表尺寸
        let chartWidth = Float(metalView.frame.width - 40)
        let chartHeight = Float(metalView.frame.height - 40)
        let barWidth = chartWidth / Float(count) * 0.7
        let barSpacing = chartWidth / Float(count) * 0.3
        
        // 创建顶点
        for (i, value) in data.enumerated() {
            let barX = 20.0 + Float(i) * (barWidth + barSpacing)
            let barHeight = (value - minValue) / valueRange * chartHeight
            
            // 柱状图的四个顶点
            let bottomLeftX = barX / Float(metalView.frame.width) * 2.0 - 1.0
            // 修复坐标系：Metal的y轴原点在左下角，而UIKit的y轴原点在左上角
            let bottomLeftY = (20.0 / Float(metalView.frame.height)) * 2.0 - 1.0
            let topRightX = (barX + barWidth) / Float(metalView.frame.width) * 2.0 - 1.0
            // 修复坐标系：Metal的y轴原点在左下角，而UIKit的y轴原点在左上角
            let topRightY = ((20.0 + barHeight) / Float(metalView.frame.height)) * 2.0 - 1.0
            
            // 底部左
            vertices.append(Vertex(position: SIMD2<Float>(bottomLeftX, bottomLeftY), color: SIMD4<Float>(0.0, 0.7, 0.0, 1.0)))
            // 底部右
            vertices.append(Vertex(position: SIMD2<Float>(topRightX, bottomLeftY), color: SIMD4<Float>(0.0, 0.7, 0.0, 1.0)))
            // 顶部左
            vertices.append(Vertex(position: SIMD2<Float>(bottomLeftX, topRightY), color: SIMD4<Float>(0.0, 0.7, 0.0, 1.0)))
            // 顶部右
            vertices.append(Vertex(position: SIMD2<Float>(topRightX, topRightY), color: SIMD4<Float>(0.0, 0.7, 0.0, 1.0)))
            
            // 两个三角形的索引
            let baseIndex = UInt16(vertices.count - 3)
            indices.append(baseIndex)
            indices.append(baseIndex + 1)
            indices.append(baseIndex + 2)
            indices.append(baseIndex + 1)
            indices.append(baseIndex + 3)
            indices.append(baseIndex + 2)
        }
        
        return (vertices, indices)
    }
    
    // MARK: - 更新Uniforms
    private func updateUniforms() {
        let uniforms = Uniforms(
            chartType: UInt32(chartType),
            dataCount: UInt32(chartType == 0 ? fuelConsumptionData.count : mileageData.count)
        )
        
        // 复制数据到uniforms缓冲区
        let uniformsPointer = uniformBuffer.contents().bindMemory(to: Uniforms.self, capacity: 1)
        uniformsPointer.pointee = uniforms
    }
    
    // MARK: - 事件处理
    @objc private func timeRangeChanged() {
        currentTimeRange = TimeRange.allCases[segmentedControl.selectedSegmentIndex]
        generateData(for: currentTimeRange)
    }
    
    @objc private func chartTypeChanged() {
        chartType = chartTypeSegmentedControl.selectedSegmentIndex
        updateVertexData()
        updateUniforms()
        metalView.setNeedsDisplay()
    }
    
    // MARK: - 数据结构
    // 顶点结构
    // 面试考点：顶点结构定义了每个顶点的数据，如位置、颜色、纹理坐标等
    struct Vertex {
        var position: SIMD2<Float>
        var color: SIMD4<Float>
    }
    
    // Uniforms结构
    struct Uniforms {
        var chartType: UInt32
        var dataCount: UInt32
    }
}

// MARK: - MTKViewDelegate
// 面试考点：MTKViewDelegate协议定义了Metal视图的渲染回调方法
extension Demo1ViewController: MTKViewDelegate {
    
    // 绘制方法
    // 面试考点：draw方法是Metal渲染的核心，负责执行渲染命令
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        // 创建命令缓冲区
        // 面试考点：命令缓冲区存储要提交给GPU的命令
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        // 创建渲染命令编码器
        // 面试考点：渲染命令编码器用于编码渲染命令，如设置管线状态、绑定缓冲区、绘制等
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        // 设置渲染管线状态
        renderEncoder?.setRenderPipelineState(pipelineState)
        
        // 绑定顶点缓冲区
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        // 绑定uniforms缓冲区
        renderEncoder?.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        
        // 绘制
        if chartType == 0 {
            // 折线图 - 线
            renderEncoder?.drawIndexedPrimitives(type: .line, indexCount: indexBuffer!.length / MemoryLayout<UInt16>.stride, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
        } else {
            // 柱状图 - 三角形
            renderEncoder?.drawIndexedPrimitives(type: .triangle, indexCount: indexBuffer!.length / MemoryLayout<UInt16>.stride, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
        }
        
        // 结束编码
        renderEncoder?.endEncoding()
        
        // 呈现drawable
        commandBuffer?.present(drawable)
        
        // 提交命令缓冲区
        // 面试考点：提交命令缓冲区后，GPU会执行其中的命令
        commandBuffer?.commit()
    }
    
    // 调整大小方法
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // 视图大小变化时的处理
    }
}

// MARK: - Metal着色器
/*
// 顶点着色器
vertex float4 vertexShader(constant Vertex *vertices [[buffer(0)]],
                          constant Uniforms *uniforms [[buffer(1)]],
                          uint vertexID [[vertex_id]]) {
    Vertex vertex = vertices[vertexID];
    return float4(vertex.position, 0.0, 1.0);
}

// 片段着色器
fragment float4 fragmentShader(VertexOut vertexOut [[stage_in]],
                             constant Uniforms *uniforms [[buffer(1)]]) {
    // 简单返回顶点颜色
    return vertexOut.color;
}
*/

// MARK: - Metal优势及OKX应用场景
/*
Metal优势：
1. 高性能：直接访问GPU硬件，减少CPU开销，适合实时数据可视化
2. 低延迟：渲染命令直接提交给GPU，减少中间层，适合金融行情等对延迟敏感的场景
3. 并行计算：充分利用GPU的并行计算能力，适合处理大量数据
4. 灵活性：可自定义渲染管线，实现复杂的视觉效果
5. 跨平台：支持iOS、macOS、tvOS等Apple平台

OKX等金融公司的应用场景：
1. 行情图表：使用Metal绘制K线图、分时图等，支持实时数据更新
2. 技术指标：利用GPU并行计算能力，实时计算MACD、KDJ等技术指标
3. 多图表布局：同时渲染多个图表，保持流畅的滚动和缩放
4. 数据可视化：高效处理和渲染大量市场数据
5. 动画效果：实现平滑的图表过渡和动画效果

面试考点总结：
1. Metal基本概念：设备、命令队列、渲染管线、着色器等
2. 渲染流程：从顶点数据到最终像素的处理过程
3. 性能优化：使用缓冲区、减少CPU-GPU数据传输、合理使用uniforms等
4. 着色器编程：Metal Shading Language的基本语法和使用
5. 并行计算：利用GPU并行处理数据的能力
6. 实际应用：如何在金融、游戏等场景中应用Metal提高性能
*/
