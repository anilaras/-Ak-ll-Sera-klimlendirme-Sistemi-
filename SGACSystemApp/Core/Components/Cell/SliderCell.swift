//
//  SliderCell.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 27.11.2024.
//

import SwiftUI

struct SliderCell: View {
    
    @Binding var sliderValue: Double
    
    @Binding var model: SensorValueModel
    
    @Binding var ledModel: LedModel
    
    @State var title: String = ""
    
    @State var minValue: Double = 0
    @State var maxValue: Double = 100
    
    @State var isThreshold: Bool = false
    
    @State private var isDragging: Bool = false
    @State private var timer: Timer?
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Text("\(Int(sliderValue))")
                    .foregroundColor(.white)
            }
            .padding(.bottom, 8)
            .padding([.leading, .trailing])
            
            Slider(
                value: Binding(
                    get: { self.sliderValue },
                    set: { newValue in
                        self.sliderValue = newValue
                        self.startTimer()
                    }
                ),
                in: minValue...maxValue
            )
            .padding(.horizontal, 16)
            
        }
        .padding()
        .background(.ultraThinMaterial)
        .background(Color.black)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding([.leading,.top,.trailing])
    }
    
    private func startTimer() {
        timer?.invalidate()
        isDragging = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            isDragging = false
            onSliderChanged()
        }
    }
    
    private func onSliderChanged() {
        if isThreshold {
            Service.updateSensorValue(model: model) { result in
                switch result {
                case .success(let success):
                    print(success.message)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        } else {
            Service.updateLedValue(model: ledModel) { result in
                switch result {
                case .success(let success):
                    print(success.message)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    SliderCell(sliderValue: .constant(0), model: .constant(SensorValueModel(id: 0, soilMoisture: 0, lightLevel: 0, gasLevel: 0, airPressure: 0, temperature: 0, humidity: 0, updatedAt: "")), ledModel: .constant(LedModel(id: 0, red: 0, green: 0, blue: 0, brightness: 0, updatedAt: "")))
}
