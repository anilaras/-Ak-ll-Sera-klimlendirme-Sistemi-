//
//  HomeInfoCell.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 25.11.2024.
//

import SwiftUI

struct HomeInfoCell: View {
    
    @State var title: String = ""
    
    @State var value: String = ""
    
    @State var backButtonAction: (() -> Void)?
    @State var messageButtonAction: (() -> Void)?
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                Text(value)
                    .foregroundColor(Color.black.opacity(0.7))
                
                Spacer()
            }
            .padding(.top, 1)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
//        .padding()
    }
}

#Preview {
    HStack {
        Spacer()
        HomeInfoCell()
        
        Spacer()
        
        HomeInfoCell()
        
        Spacer()
    }
    .padding()
    
}
