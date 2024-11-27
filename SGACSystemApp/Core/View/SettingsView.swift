//
//  SettingsView.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 25.11.2024.
//

import SwiftUI
import SwiftUICharts

struct SettingsView: View {
    
    @State private var model: SensorValueModel = SensorValueModel(id: 0, soilMoisture: 0, lightLevel: 0, gasLevel: 0, airPressure: 0, temperature: 0, humidity: 0, updatedAt: "")
    
    @State private var ledModel: LedModel = LedModel(id: 0, red: 0, green: 0, blue: 0, brightness: 0, updatedAt: "")
        
    @State private var bgColor = Color(.red)
    
    @State private var showModals: Bool = false
    
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
            
            if showModals {
                ScrollView {
                    
                    HStack {
                        Text("Eşik Ayarları")
                            .foregroundColor(.white)
                            .font(.system(size: 18).bold())
                            
                        Spacer()
                    }
                    .padding(.leading)
                    
                    SliderCell(sliderValue: $model.soilMoisture, model: $model, ledModel: $ledModel, title: "Toprak Nemi", minValue: 0, maxValue: 1024, isThreshold: true)
                    
                    SliderCell(sliderValue: $model.lightLevel, model: $model, ledModel: $ledModel, title: "Işık Seviyesi", minValue: 0, maxValue: 1024, isThreshold: true)
                    
                    SliderCell(sliderValue: $model.gasLevel, model: $model, ledModel: $ledModel, title: "Gaz Seviyesi", minValue: 0, maxValue: 1024, isThreshold: true)
                    
                    SliderCell(sliderValue: $model.airPressure, model: $model, ledModel: $ledModel, title: "Hava Basıncı", minValue: 600, maxValue: 1200, isThreshold: true)
                    
                    SliderCell(sliderValue: $model.temperature, model: $model, ledModel: $ledModel, title: "Sıcaklık", minValue: 0, maxValue: 50, isThreshold: true)
                    
                    SliderCell(sliderValue: $model.humidity, model: $model, ledModel: $ledModel, title: "Nem", minValue: 0, maxValue: 100, isThreshold: true)
                    
                    HStack {
                        Text("Işık Ayarları")
                            .foregroundColor(.white)
                            .font(.system(size: 18).bold())
                            
                        Spacer()
                    }
                    .padding([.leading,.top])
                    
                    SliderCell(sliderValue: $ledModel.brightness, model: $model, ledModel: $ledModel, title: "Parlaklık", minValue: 0, maxValue: 100, isThreshold: false)
                    
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
            } else {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .background(Color(hex: "#232F34"))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)
        .onChange(of: bgColor, perform: { newValue in
            let r = bgColor.components.red
            let g = bgColor.components.green
            let b = bgColor.components.blue
            
            ledModel.red = Double(Int(r))
            ledModel.green = Double(Int(g))
            ledModel.blue = Double(Int(b))
            
            Service.updateLedValue(model: ledModel) { result in
                switch result {
                case .success(let success):
                    print(success.message)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        })
        .onAppear {
            fetchValues()
        }
    }
    
    private func fetchValues() {
        showModals = false
        Service.getSensorValue { result in
            switch result {
            case .success(let success):
                self.model = success
                showModals = true
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        Service.getLedValue { result in
            switch result {
            case .success(let success):
                self.ledModel = success
                let uiColor = UIColor(ciColor: CIColor(red: CGFloat(success.red) / 255.0 , green: CGFloat(success.green) / 255.0, blue: CGFloat(success.blue) / 255.0))
                bgColor = Color(uiColor: uiColor)
                showModals = true
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

#Preview {
    SettingsView()
}
