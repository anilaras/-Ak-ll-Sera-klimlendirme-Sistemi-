//
//  SettingsView.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 25.11.2024.
//

import SwiftUI
import SwiftUICharts

struct SettingsView: View {
    
    @State private var soilMoisture: Double = 30
    
    @State private var lightLevel: Double = 500
    
    @State private var gasLevel: Double = 1000
    
    @State private var airPressure: Double = 1013
    
    @State private var temperature: Double = 25
    
    @State private var humidity: Double = 60
    
    @State private var brightness: Double = 100
    
    @State private var bgColor = Color(.red)
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Ayarlar")
                    .foregroundColor(.white)
                    .font(.system(size: 24).bold())
                    .multilineTextAlignment(.center)
                    .padding(.top)
                Spacer()
            }
            
            ScrollView {
                
                HStack {
                    Text("Eşik Ayarları")
                        .foregroundColor(.white)
                        .font(.system(size: 18).bold())
                        
                    Spacer()
                }
                .padding(.leading)
                
                SliderCell(sliderValue: $soilMoisture, title: "Toprak Nemi", minValue: 0, maxValue: 1024)
                
                SliderCell(sliderValue: $lightLevel, title: "Işık Seviyesi", minValue: 0, maxValue: 1024)
                
                SliderCell(sliderValue: $gasLevel, title: "Gaz Seviyesi", minValue: 0, maxValue: 1024)
                
                SliderCell(sliderValue: $airPressure, title: "Hava Basıncı", minValue: 600, maxValue: 1200)
                
                SliderCell(sliderValue: $temperature, title: "Sıcaklık", minValue: 0, maxValue: 50)
                
                SliderCell(sliderValue: $humidity, title: "Nem", minValue: 0, maxValue: 100)
                
                HStack {
                    Text("Işık Ayarları")
                        .foregroundColor(.white)
                        .font(.system(size: 18).bold())
                        
                    Spacer()
                }
                .padding([.leading,.top])
                
                SliderCell(sliderValue: $brightness, title: "Parlaklık", minValue: 0, maxValue: 100)
                
                ColorPicker(selection: $bgColor, supportsOpacity: true, label: {
                    HStack {
                        Text("Işık Rengi (R: \(bgColor.components.red), G: \(bgColor.components.green), B: \(bgColor.components.blue))")
                            .font(.title3.bold())
                            .foregroundColor(Color(hex: "#283739"))
                        Spacer()
                        Image(systemName: "arrow.right")
                            .renderingMode(.template)
                            .foregroundColor(Color(hex: "#283739"))
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                })
                .padding([.leading,.top,.trailing])
                
            }
        }
        .background(Color(hex: "#232F34"))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)
        .onChange(of: bgColor) { newValue in
//            let rgb = bgColor.components
//            print("\(rgb.red), \(rgb.green), \(rgb.blue)")
        }
    }
}

#Preview {
    SettingsView()
}
