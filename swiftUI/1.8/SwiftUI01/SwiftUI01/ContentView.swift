//
//  ContentView.swift
//  SwiftUI01
//
//  Created by CQCA202121101_2 on 2025/11/3.
//

import SwiftUI

struct ContentView: View {
    @State private var account: String = ""
    @State private var password: String = ""
    
 
    var body: some View {
        
        VStack {
            Spacer()
                .frame(height: 300)
            TextField("请输入账号", text: $account)
                .padding([.leading, .trailing], 20)
                .background(Color.gray)
                .background(
                        // 绘制带圆角的边框
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2) // 边框颜色和宽度
                    )
                .cornerRadius(10)
                .onChange(of: password) { oldValue, newValue in
                    print("账号newValue: \(newValue)")
                }
                .padding([.leading, .trailing], 20)

            
            TextField("请输入密码", text: $password)
                .padding([.leading, .trailing], 20)
                .background(Color.gray)
                .background(
                        // 绘制带圆角的边框
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2) // 边框颜色和宽度
                    )
                .cornerRadius(10)
                .onChange(of: password) { oldValue, newValue in
                    print("密码newValue: \(newValue)")
                }
                .padding([.leading, .trailing], 20)
                

            Button("Login") {
                print("点击了")
                
                if account == "123456" && password == "abcdefg" {
                    print("登录成功")
                } else {
                    print("登录失败")
                }
            }
            .frame(width: 100, height: 40)
            .background(Color.red)
            .background(
                    // 绘制带圆角的边框
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green, lineWidth: 2) // 边框颜色和宽度
                )
            .cornerRadius(20)
            
            Spacer()
        }
        

        
    }
        
}


#Preview {
    ContentView()
}
