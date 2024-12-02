//
//  PastDetailView.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 29.11.2024.
//

import SwiftUI
import SwiftUICharts

struct PastDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var title: String = ""
    
    @State var pastValue: [PastValueModel] = []
    @State var showingPastValue: [PastValueModel] = []
    
    @State var chartTitle: String = "Toprak Nemi"
    @State var chartData: [Double] = []
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "control")
                            .rotationEffect(.degrees(-90))
                        Text("Geri")
                    }

                    Spacer()
                }
                .padding()
                
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: 20).bold())
                    .multilineTextAlignment(.center)
            }
            
            ScrollView {
                
                menuView
                
                LineChartView(data: chartData,
                              title: chartTitle,
                              legend: title,
                              form: CGSize(width: getRect().width - 34, height: 220))
                
                ForEach(showingPastValue, id: \.id) { item in
                    PastDetailCell(model: item, soilMoisture: item.soilMoisture,airPressure: item.pressure,airTemperature: item.temperature,lightAmount: item.light,gasAmount: item.rawGas, humidity: item.humidity, time: DateFormatterHelper.dateFormatterForDetails(with: item.createdAt))
                }
            }
            
            Spacer()
        }
        .background(Color.backgroundColor())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)
        .onAppear {
            self.showingPastValue = pastValue.filter {
                DateFormatterHelper.dateFormatterForTabPast(with: $0.createdAt) == title
            }
            
            var count: Int = 0
            for value in showingPastValue {
                self.showingPastValue[count].createdAt = DateFormatterHelper.dateFormatterForFixed(with: value.createdAt)
                count += 1
            }
            
            var uniqueDates = Set<String>()
            showingPastValue = showingPastValue.filter { value in
                let formattedDate = DateFormatterHelper.dateFormatterForTabPast(with: value.createdAt)
                return uniqueDates.insert(formattedDate).inserted
            }
            
            chartTitle = "Toprak Nemi"
            chartData = showingPastValue.map { Double($0.soilMoisture) }
        }
    }
}

#Preview {
    PastDetailView()
}

extension PastDetailView {
    private var menuView: some View {
        HStack {
            Spacer()
            
            Menu {
                Button {
                    chartTitle = "Toprak Nemi"
                    chartData = showingPastValue.map { Double($0.soilMoisture) }
                } label: {
                    Label("Toprak Nemi", systemImage: "drop.fill")
                }
                
                Button {
                    chartTitle = "Hava Basıncı"
                    chartData = showingPastValue.map { Double($0.pressure) }
                } label: {
                    Label("Hava Basıncı", systemImage: "barometer")
                }
                
                Button {
                    chartTitle = "Hava Sıcaklığı"
                    chartData = showingPastValue.map { Double($0.temperature) }
                } label: {
                    Label("Hava Sıcaklığı", systemImage: "thermometer")
                }
                
                Button {
                    chartTitle = "Işık Miktarı"
                    chartData = showingPastValue.map { Double($0.light) }
                } label: {
                    Label("Işık Miktarı", systemImage: "lightbulb")
                }
                
                Button {
                    chartTitle = "Gaz Miktarı"
                    chartData = showingPastValue.map { Double($0.rawGas) }
                } label: {
                    Label("Gaz Miktarı", systemImage: "leaf")
                }
                
                Button {
                    chartTitle = "Ortam Nemi"
                    chartData = showingPastValue.map { Double($0.humidity) }
                } label: {
                    Label("Ortam Nemi", systemImage: "drop")
                }
            } label: {
                HStack {
                    Text(chartTitle)
                        .foregroundColor(.white)
                    
                    Image(systemName: "control")
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(180))
                }
                .padding(10)
                .background(.ultraThinMaterial)
                .background(Color.black)
                .cornerRadius(10)
            }
        }
        .padding([.trailing], 22)
        .padding(.top, 2)
    }
}
