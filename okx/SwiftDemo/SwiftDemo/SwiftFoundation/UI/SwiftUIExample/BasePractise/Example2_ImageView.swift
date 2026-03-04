//
//  Example2_ImageView.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/2/28.
//

import SwiftUI

struct Example2_ImageView: View {
    var body: some View {
        Image("myCar")
            .resizable() //Unlocks the fixed default size of SwiftUI Image views (whether loading from asset catalogs, system symbols, or external sources).
            .scaledToFit() //Scales the image to fit within its available frame while preserving the aspect ratio (width:height proportion).
            .frame(width: 200)
            .cornerRadius(100)
            .shadow(radius: 10)
        
        Text("MyCar")
        Spacer()
    }
}

#Preview {
    Example2_ImageView()
}
