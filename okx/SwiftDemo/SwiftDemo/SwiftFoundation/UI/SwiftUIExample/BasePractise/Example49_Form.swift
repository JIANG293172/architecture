//
//  Example49_Form.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/3.
//

import SwiftUI

struct Example49_Form: View {
    @State private var name = ""
    @State private var age = ""
    @State private var isSubscribed = false
    @State private var favoriteColor = "Red"
    let colors = ["Red", "Blue", "Green", "Yellow"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("personal info") {
                    TextField("fullname", text: $name)
                    TextField("age", text: $age)
                }
                
                Section("preferences") {
                    Toggle("subscribe to newsletter", isOn: $isSubscribed)
                    
                    Picker("favorite color", selection: $favoriteColor) {
                        ForEach(colors, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    Button("save") {
                        print("name: \(name), age : \(age) subscribed: \(isSubscribed), color: \(favoriteColor)")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
            }
            .navigationTitle("profile form")
            
        }
        
    }
}

#Preview {
    Example49_Form()
}
