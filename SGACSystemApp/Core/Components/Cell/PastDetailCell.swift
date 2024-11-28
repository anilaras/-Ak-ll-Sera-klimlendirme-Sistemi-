//
//  PastDetailCell.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 29.11.2024.
//

import SwiftUI

struct PastDetailCell: View {
    
    @State var model: PastValueModel
    
    let soilMoisture: Int
    let airPressure: Int
    let airTemperature: Int
    let lightAmount: Int
    let gasAmount: Int
    let time: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "drop.fill")
                    .foregroundColor(.blue)
                Text("Toprak Nemi")
                    .font(.headline)
                Spacer()
                Text("\(soilMoisture)%")
                    .font(.body)
            }
            
            HStack {
                Image(systemName: "barometer")
                    .foregroundColor(.orange)
                Text("Hava Basıncı")
                    .font(.headline)
                Spacer()
                Text("\(airPressure) HPA")
                    .font(.body)
            }
            
            HStack {
                Image(systemName: "thermometer")
                    .foregroundColor(.red)
                Text("Hava Sıcaklığı")
                    .font(.headline)
                Spacer()
                Text("\(airTemperature)°C")
                    .font(.body)
            }
            
            HStack {
                Image(systemName: "lightbulb")
                    .foregroundColor(.yellow)
                Text("Işık Miktarı")
                    .font(.headline)
                Spacer()
                Text("\(lightAmount) Lümen")
                    .font(.body)
            }
            
            HStack {
                Image(systemName: "leaf")
                    .foregroundColor(.green)
                Text("Gaz Miktarı")
                    .font(.headline)
                Spacer()
                Text("\(gasAmount) PPM")
                    .font(.body)
            }
            
            Divider()
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.gray)
                Text("Saat")
                    .font(.subheadline)
                Spacer()
                Text(time)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding([.leading,.top,.trailing])
    }
}

#Preview {
    PastDetailCell(model: PastValueModel(id: 0, rawGas: 100, correctedPpmGas: 10, light: 10, soilMoisture: 10, temperature: 10, humidity: 10, pressure: 10, createdAt: "2024-12-31"), soilMoisture: 45,
                   airPressure: 1015,
                   airTemperature: 25,
                   lightAmount: 2000,
                   gasAmount: 300,
                   time: "12:45 PM")
}
