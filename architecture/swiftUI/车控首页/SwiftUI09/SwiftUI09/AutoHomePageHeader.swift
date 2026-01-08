//
//  AutoHomePageHeader.swift
//  SwiftUI09
//
//  Created by CQCA202121101_2 on 2026/1/8.
//

import SwiftUI

struct AutoHomePageHeader: View {
    let initTitle: String
    @State private var currentTitle: String
    
    // 初始化（对应 Flutter 的 initState）
    init(initTitle: String) {
        self.initTitle = initTitle
        self._currentTitle = State(initialValue: initTitle)
    }
    
    // 切换标题（对应 Flutter 的 _changeTitle）
    private func changeTitle() {
        currentTitle = currentTitle == initTitle
            ? "当前车辆：长安CS75 PLUS"
            : initTitle
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(currentTitle)
                .font(.system(size: 18, weight: .bold))
            
            Spacer()
            
            Button(action: changeTitle) {
                Text("切换标题")
                    .font(.system(size: 14))
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(height: 60)
        .padding(.horizontal, 16)
        .background(Color.blue.opacity(0.1)) // 对应 Colors.blue[50]
    }
}
