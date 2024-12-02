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
    let humidity: Int
    let time: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "drop.fill")
                    .foregroundColor(.blue)
                Text("Toprak Nemi")
                    .foregroundColor(.white)
                    .font(.headline)
                Spacer()
                Text("\(soilMoisture)%")
                    .foregroundColor(.white)
                    .font(.body)
            }
            
            HStack {
                Image(systemName: "barometer")
                    .foregroundColor(.orange)
                Text("Hava Basıncı")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("\(airPressure) HPA")
                    .foregroundColor(.white)
                    .font(.body)
            }
            
            HStack {
                Image(systemName: "thermometer")
                    .foregroundColor(.red)
                Text("Hava Sıcaklığı")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("\(airTemperature)°C")
                    .font(.body)
                    .foregroundColor(.white)
            }
            
            HStack {
                Image(systemName: "lightbulb")
                    .foregroundColor(.yellow)
                Text("Işık Miktarı")
                    .foregroundColor(.white)
                    .font(.headline)
                Spacer()
                Text("\(lightAmount) Lümen")
                    .font(.body)
                    .foregroundColor(.white)
            }
            
            HStack {
                Image(systemName: "leaf")
                    .foregroundColor(.green)
                Text("Gaz Miktarı")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("\(gasAmount) PPM")
                    .font(.body)
                    .foregroundColor(.white)
            }
            
            HStack {
                Image(systemName: "drop")
                    .foregroundColor(.orange)
                Text("Ortam Nemi")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("\(humidity)%")
                    .font(.body)
                    .foregroundColor(.white)
            }
            
            Divider()
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.white)
                Text("Saat")
                    .foregroundColor(.white)
                    .font(.subheadline)
                Spacer()
                Text(time)
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .background(Color.black)
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
                   gasAmount: 300, humidity: 100,
                   time: "12:45 PM")
}
