//
//  LineChartComponent.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 26.11.2024.
//

import SwiftUI
import SwiftUICharts

struct LineChartComponent: View {
    
    @Binding var showModal: Bool
    
    @State var title: String = "Toprak Nem Durumu"
    @State var legend: String = "Son 7 gün"
    
    @State var data: [Double] = [30110,31923,32381,32736,31896,30402,32137]
    
    var body: some View {
        VStack {
            LineChartView(data: data,
                          title: title,
                          legend: legend,
                          form: ChartForm.extraLarge)
            
            HStack {
                Spacer()
                
                Button {
                    showModal = false
                } label: {
                    Text("Tamam")
                }
            }
            .padding([.top,.bottom])
        }
        .padding(14)
        .background(Color(hex: "#232F34"))
        .shadow(radius: 10)
        .cornerRadius(10)
        .padding(20)
        .frame(width: getRect().width)
    }
}

#Preview {
    LineChartComponent(showModal: .constant(false))
}
