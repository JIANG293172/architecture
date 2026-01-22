//
//  RegisterView.swift
//  RxSwift02
//
//  Created by CQCA202121101_2 on 2025/11/17.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("注册页面")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("注册功能开发中...")
                    .foregroundColor(.secondary)
                
                Button("返回登录") {
                    dismiss()
                }
                .foregroundColor(.blue)
            }
        }
        .navigationTitle("注册")
        .navigationBarTitleDisplayMode(.inline)
    }
}
