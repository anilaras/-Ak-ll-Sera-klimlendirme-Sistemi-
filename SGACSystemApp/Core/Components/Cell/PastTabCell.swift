//
//  PastTabCell.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 28.11.2024.
//

import SwiftUI

struct PastTabCell: View {
    
    @State var title: String = "2024-10-10"
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18).bold())
                .foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "control")
                .rotationEffect(.degrees(90))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .padding([.leading, .top,.trailing])
    }
}

#Preview {
    PastTabCell()
}
