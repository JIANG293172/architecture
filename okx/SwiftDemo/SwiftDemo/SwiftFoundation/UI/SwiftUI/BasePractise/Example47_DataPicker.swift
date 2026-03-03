//
//  Example47_DataPicker.swift
//  SwiftDemo
//
//  Created by CQCA202121101_2 on 2026/3/3.
//

import SwiftUI

struct Example47_DataPicker: View {
    @State private var selectedDate = Date()
    
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .year, value: -1, to: Date())!
        let endDate = calendar.date(byAdding: .year, value: 1, to: Date())!
        
        return startDate...endDate
    }()
    
    var body: some View {
        VStack(spacing: 20) {
            DatePicker("select date", selection: $selectedDate, in: dateRange, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
            
            Text("selected date: \(selectedDate.formatted())")
                .font(.subheadline)
        }
    }
}

#Preview {
    Example47_DataPicker()
}
