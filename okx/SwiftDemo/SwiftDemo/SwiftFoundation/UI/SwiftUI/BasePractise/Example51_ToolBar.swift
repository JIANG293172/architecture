//
//  Example51_ToolBar.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/3.
//

import SwiftUI

struct Example51_ToolBar: View {
    @State private var isEditing = false
    
    var body: some View {
        NavigationStack {
            Text("main content")
                .navigationTitle("toolbar emample")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("edit") {
                            isEditing.toggle()
                        }
                        .foregroundColor(isEditing ? .red : .blue)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu("actions") {
                            Button("shate") {
                                print("share")
                            }
                            Button("delete", role: .destructive) {
                                print("deleted")
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        HStack {
                            Spacer()
                            Button("save") {
                                print("saved")
                            }
                            Spacer()
                            Button("camcel") {
                                print("canceled")
                            }
                            Spacer()
                        }
                    }
                    
                }
            
        }
        
        
    }
}

#Preview {
    Example51_ToolBar()
}
