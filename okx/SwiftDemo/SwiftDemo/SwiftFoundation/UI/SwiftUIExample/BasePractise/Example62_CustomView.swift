//
//  Example62_CustomView.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/3/3.
//

import SwiftUI

struct Example62_CardView: View {
    let title: String
    let subTitle: String
    let icon: String
    
    init(title: String, subTitle: String, icon: String) {
        self.title = title
        self.subTitle = subTitle
        self.icon = icon
    }
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(subTitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct Example62_CustomView: View {
    var body: some View {
        
        VStack(spacing: 10) {
            Example62_CardView(title: "notification", subTitle: "new message", icon: "bell.fill")
            Example62_CardView(title: "profile", subTitle: "edit you profile", icon: "person.fill")
            Example62_CardView(title: "setting", subTitle: "adjust app setting", icon: "gear.fill")
        }
        .padding()
        .background()
    }
}

#Preview {
    Example62_CustomView()
}
