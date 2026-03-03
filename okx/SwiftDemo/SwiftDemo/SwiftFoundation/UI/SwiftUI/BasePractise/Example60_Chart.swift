//
//  Example60_Chart.swift
//  SwiftDemo
//
//  Created by taojiang on 2026/3/3.
//

import SwiftUI
import Charts

struct Example60_SalesData: Identifiable {
    let id = UUID()
    let month: String
    let amount: Double
}

struct Example60_Chart: View {
    let salesData = [
        Example60_SalesData(month: "Jan", amount: 1000),
        Example60_SalesData(month: "Feb", amount: 2222),
        Example60_SalesData(month: "Mar", amount: 3333),
        Example60_SalesData(month: "Apr", amount: 4444),
        Example60_SalesData(month: "May", amount: 5555)

        
    ]
    
    var body: some View {
        VStack {
            Text("monthly sales")
                .font(.title)
            
            Chart(salesData) { data in
                BarMark (x: .value("Month", data.month),
                         y: .value("Sales", data.amount)
                )
                .foregroundStyle(by: .value("Month", data.month))
                
                LineMark(x: .value("Month", data.month), y: .value("Sales", data.amount))
                    .foregroundStyle(.red)
                    .lineStyle(StrokeStyle(lineWidth: 2))
            }
            .chartXAxis {
                AxisMarks(position: .bottom) { _ in
                    AxisGridLine()
                    AxisTick()
                    AxisGridLine()
                }
            }
            .frame(height: 100)
            .padding()
            
        }
    }
}

#Preview {
    Example60_Chart()
}
