//
//  SliderCell.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 27.11.2024.
//

import SwiftUI

struct SliderCell: View {
    @Binding var sliderValue: Double
    
    @State var title: String = ""
    
    @State var minValue: Double = 0
    @State var maxValue: Double = 100
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Text("\(sliderValue, specifier: "%.2f")")
                    
            }
            .padding(.bottom, 8)
            .padding([.leading, .trailing])
            
            Slider(value: $sliderValue, in: minValue...maxValue)
                .padding(.horizontal, 16)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding([.leading,.top,.trailing])
    }
}

#Preview {
    SliderCell(sliderValue: .constant(0))
}
