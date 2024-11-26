//
//  StatisticView.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 25.11.2024.
//

import SwiftUI
import SwiftUICharts

struct StatisticView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("İstatistikler")
                    .foregroundColor(.white)
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                    .padding(.top)
                Spacer()
            }
            
            ScrollView {
                
                VStack {
                    LineChartView(data: [30110,31923,32381,32736,31896,30402,32137],
                                  title: "Toprak Nem Durumu",
                                  legend: "Son 7 gün",
                                  form: ChartForm.extraLarge)
    //                .padding(.top)
                    
                    LineChartView(data: [30110,31923,32381,32736,31896,30402,32137],
                                  title: "Sıcaklık Değişimi",
                                  legend: "Son 7 gün",
                                  form: ChartForm.extraLarge)
    //                .padding(.top)
                    
                    LineChartView(data: [30110,31923,32381,32736,31896,30402,32137],
                                  title: "Hava Basıncı Değişimi",
                                  legend: "Son 7 gün",
                                  form: ChartForm.extraLarge)
    //                .padding(.top)
                }
                .padding()
                .frame(width: getRect().width - 10)
            }
        }
        .frame(width: getRect().width)
        .background(Color(hex: "#232F34"))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)
    }
}

#Preview {
    StatisticView()
}
