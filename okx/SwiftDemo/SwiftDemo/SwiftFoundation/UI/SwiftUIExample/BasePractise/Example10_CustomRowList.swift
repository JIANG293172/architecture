//
//  Example10_CustomRowList.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example10Task: Identifiable {
    let id = UUID()
    let title: String
    let isCompleted: Bool
}

struct Example10_CustomRowList: View {
    @State var tasks = [
        Example10Task(title: "Learn SwiftUI", isCompleted: true),
        Example10Task(title: "Build App", isCompleted: false),
        Example10Task(title: "Prepare for it", isCompleted: true)
    ]
    
    var body: some View {
        List(tasks) { task in
            HStack {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                
                Text(task.title)
                    .strikethrough(task.isCompleted)
            }
        }
        .navigationTitle("Task List")
        
        List {
            ForEach(tasks, id: \.id) { task in
                HStack {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isCompleted ? .green : .gray)
                    
                    Text(task.title)
                        .strikethrough(task.isCompleted)
                }.onTapGesture {
                    print("点击某行\(task.title)")
                }
            }
            .onDelete(perform: deleteTask)
            .onMove(perform: moveTask)
        }
    }
    
    // 6. 核心修复：移除mutating关键字
    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    // 6. 核心修复：移除mutating关键字
    private func moveTask(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
    }
}

#Preview {
    Example10_CustomRowList()
}
