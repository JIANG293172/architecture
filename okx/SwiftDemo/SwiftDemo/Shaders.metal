#include <metal_stdlib>
using namespace metal;

// 顶点结构
struct Vertex {
    float2 position;
    float4 color;
};

// 顶点输出结构
struct VertexOut {
    float4 position [[position]];
    float4 color;
};

// Uniforms结构
struct Uniforms {
    uint chartType;
    uint dataCount;
};

// 顶点着色器
// 面试考点：顶点着色器负责将顶点坐标转换为裁剪空间坐标
vertex VertexOut vertexShader(constant Vertex *vertices [[buffer(0)]],
                             constant Uniforms *uniforms [[buffer(1)]],
                             uint vid [[vertex_id]]) {
    Vertex v = vertices[vid];
    
    VertexOut out;
    out.position = float4(v.position, 0.0, 1.0);
    out.color = v.color;
    
    return out;
}

// 片段着色器
// 面试考点：片段着色器负责计算每个像素的最终颜色
fragment float4 fragmentShader(VertexOut in [[stage_in]],
                              constant Uniforms *uniforms [[buffer(1)]]) {
    // 简单返回顶点颜色
    return in.color;
}
