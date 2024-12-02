//
//  PastView.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 28.11.2024.
//

import SwiftUI
import SwiftUICharts

struct PastView: View {
    
    @State private var pastValue: [PastValueModel] = []
    @State private var showingPastValue: [PastValueModel] = []
    
    @State var chartTitle: String = "Toprak Nemi"
    @State var chartLegend: String = ""
    @State var chartData: [Double] = []
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Geçmiş")
                    .foregroundColor(.white)
                    .font(.system(size: 24).bold())
                    .multilineTextAlignment(.center)
                    .padding(.top)
                Spacer()
            }
            
            ScrollView {
                
                menuView
                
                LineChartView(data: chartData,
                              title: chartTitle,
                              legend: chartLegend,
                              form: CGSize(width: getRect().width - 34, height: 220))
                
                ForEach(showingPastValue, id: \.id) { pastValue in
                    NavigationLink {
                        PastDetailView(title: DateFormatterHelper.dateFormatterForTabPast(with: pastValue.createdAt), pastValue: self.pastValue)
                    } label: {
                        PastTabCell(title: DateFormatterHelper.dateFormatterForTabPast(with: pastValue.createdAt))
                    }

                }
            }
            
            Spacer()
        }
        .background(Color.backgroundColor())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)
        .onAppear {
            Service.getPastValues(startDate: "2024-01-01", endDate: "2024-12-31") { result in
                switch result {
                case .success(let success):
                    self.pastValue = success
                    var uniqueDates = Set<String>()
                    showingPastValue = success.filter { value in
                        let formattedDate = DateFormatterHelper.dateFormatterForTabPast(with: value.createdAt)
                        return uniqueDates.insert(formattedDate).inserted
                    }
                    
                    let lastAndMostRecentValue = getMostRecentValue(from: showingPastValue)
                    if let first = lastAndMostRecentValue.first, let last = lastAndMostRecentValue.last {
                        chartLegend = "\(DateFormatterHelper.dateFormatterForDetailsForPast(with: last.createdAt)) - \(DateFormatterHelper.dateFormatterForDetailsForPast(with: first.createdAt))"
                    }
                    chartTitle = "Toprak Nemi"
                    chartData = success.map { Double($0.soilMoisture) }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
    
    private func getMostRecentValue(from values: [PastValueModel]) -> [PastValueModel] {
        let dateFormatter = ISO8601DateFormatter()
        
        return values.sorted { first, second in
            guard
                let firstDate = dateFormatter.date(from: first.createdAt),
                let secondDate = dateFormatter.date(from: second.createdAt)
            else {
                return false
            }
            return firstDate > secondDate
        }
    }
}

#Preview {
    PastView()
}

extension PastView {
    private var menuView: some View {
        HStack {
            Spacer()
            
            Menu {
                Button {
                    chartTitle = "Toprak Nemi"
                    chartData = pastValue.map { Double($0.soilMoisture) }
                } label: {
                    Label("Toprak Nemi", systemImage: "drop.fill")
                }
                
                Button {
                    chartTitle = "Hava Basıncı"
                    chartData = pastValue.map { Double($0.pressure) }
                } label: {
                    Label("Hava Basıncı", systemImage: "barometer")
                }
                
                Button {
                    chartTitle = "Hava Sıcaklığı"
                    chartData = pastValue.map { Double($0.temperature) }
                } label: {
                    Label("Hava Sıcaklığı", systemImage: "thermometer")
                }
                
                Button {
                    chartTitle = "Işık Miktarı"
                    chartData = pastValue.map { Double($0.light) }
                } label: {
                    Label("Işık Miktarı", systemImage: "lightbulb")
                }
                
                Button {
                    chartTitle = "Gaz Miktarı"
                    chartData = pastValue.map { Double($0.rawGas) }
                } label: {
                    Label("Gaz Miktarı", systemImage: "leaf")
                }
                
                Button {
                    chartTitle = "Ortam Nemi"
                    chartData = pastValue.map { Double($0.humidity) }
                } label: {
                    Label("Ortam Nemi", systemImage: "drop")
                }
            } label: {
                HStack {
                    Text(chartTitle)
                        .foregroundColor(.textColor())
                    
                    Image(systemName: "control")
                        .foregroundColor(.textColor())
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
