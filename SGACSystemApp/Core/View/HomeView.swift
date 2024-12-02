//
//  HomeView.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 25.11.2024.
//

import SwiftUI
import SwiftUICharts

struct HomeView: View {
    
    @State private var value: PastValueModel?
    @State private var photo: Image = Image(systemName: "photo.artframe")
    
    var body: some View {
        ZStack {
            mainContent
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)
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
    HomeView()
}

extension HomeView {
    private var mainContent: some View {
        VStack {
            HStack {
                Spacer()
                Text("Yeşil Arge")
                    .foregroundColor(Color.textColor())
                    .font(.system(size: 24).bold())
                    .multilineTextAlignment(.center)
                    .padding(.top)
                Spacer()
            }
            
            if let item = value {
                ScrollView {
                    HStack {
                        Text("Sera Bilgisi")
                            .foregroundColor(.white)
                            .font(.system(size: 18).bold())
                            
                        Spacer()
                    }
                    .padding([.leading,.top])
                    
                    PastDetailCell(model: item, soilMoisture: item.soilMoisture,airPressure: item.pressure,airTemperature: item.temperature,lightAmount: item.light,gasAmount: item.rawGas, humidity: item.humidity,time: DateFormatterHelper.dateFormatterForDetailsForHome(with: item.createdAt))
                    
                    HStack {
                        Text("Sera Fotoğrafı")
                            .foregroundColor(.white)
                            .font(.system(size: 18).bold())
                            
                        Spacer()
                    }
                    .padding([.leading,.top])
                    
                    photo
                        .resizable()
                        .frame(height: 300)
                        .foregroundStyle(.ultraThinMaterial)
                        .foregroundColor(Color.black)
                        .cornerRadius(10)
                        .padding()
                }
            } else {
                ProgressView()
            }

            
            Spacer()
        }
        .background(Color.backgroundColor())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)
        .onAppear {
            Service.getPastValues(startDate: "", endDate: "") { result in
                switch result {
                case .success(let success):
                    value = getMostRecentValue(from: success).first
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
            
            Service.fetchPhoto { result in
                switch result {
                case .success(let success):
                    if let uiImage = UIImage(data: success) {
                        photo = Image(uiImage: uiImage)
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
}
