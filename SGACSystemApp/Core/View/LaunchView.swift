//
//  LaunchView.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 2.12.2024.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if isActive {
                TabView()
            } else {
                Color.backgroundColor().edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .cornerRadius(20)
                    Spacer()
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(2)
                    Spacer()
                    Text("© 2024 İlker Uğur Kaya")
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
                .frame(width: getRect().width)
                .background(Color.backgroundColor())
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    LaunchView()
}
