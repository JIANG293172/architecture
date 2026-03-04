//
//  Example100_FinalDemo.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/4.
//

import SwiftUI
import Combine

struct Example100_FinalDemo: View {
    @StateObject var vm = Example100_UserViewModel()
    @State var showSheet = false
    
    var body: some View {
        NavigationStack {
            List(vm.users) { user in
                Text(user.name)
            }
            .navigationTitle("users")
            .toolbar {
                Button("add") {
                    showSheet = true
                }
            }
            .sheet(isPresented: $showSheet) {
                Button("refrseh") {
                    vm.fetchUsers()
                }
            }
            .task {
                vm.fetchUsers()
            }
        }
        
    }
}

#Preview {
    Example100_FinalDemo()
}

struct Example100_User: Identifiable {
    let id = UUID()
    let name : String
}

class Example100_UserViewModel: ObservableObject {
    @Published var users = [Example100_User]()
    
    func fetchUsers() {
        users = [
            Example100_User(name: "iOS DEV"),
            Example100_User(name: "swift engineer")
        ]
    }
    
}
