//
//  Example39_DynamicList.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/2/28.
//

import SwiftUI

struct Example39_User: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
}

struct Example39_DynamicList: View {
    let users = [
        Example39_User(name: "alice", age: 25),
        Example39_User(name: "bob", age: 30),
        Example39_User(name: "charlie", age: 35)

    ]
    
    var body: some View {
        List(users) { user in
            HStack {
                Text(user.name)
                    .font(.headline)
                Spacer()
                Text("\(user.age)")
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("user list")
        
    }
}

#Preview {
    Example39_DynamicList()
}
