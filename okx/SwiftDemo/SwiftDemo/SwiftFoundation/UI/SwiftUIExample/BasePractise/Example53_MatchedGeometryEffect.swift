//
//  Example53_MatchedGeometryEffect.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/3.
//

import SwiftUI

struct Example53_MatchedGeometryEffect: View {
    @State private var showDetail = false
    @Namespace private var animationNamespace
    
    var body: some View {
        ZStack {
            if !showDetail {
                VStack {
                    Image(systemName: "star.fill")
                        .matchedGeometryEffect(id: "star", in: animationNamespace)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.yellow)
                    
                    Button("show detail") {
                        withAnimation {
                            showDetail = true
                        }
                    }
                }
            } else {
                VStack {
                    Image(systemName: "star.fill")
                        .matchedGeometryEffect(id: "star", in: animationNamespace)
                        .frame(width: 200, height: 200)
                        .foregroundColor(.yellow)
                    
                    Button("hide detail") {
                        withAnimation {
                            showDetail = false
                            
                        }
                    }
                }
            }
            
        }
    }
}

#Preview {
    Example53_MatchedGeometryEffect()
}
