//
//  PopupView.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 26.11.2024.
//

import SwiftUI

struct PopupView<Content: View>: View {
    @Binding var close: Bool
    var content: Content
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    close = false
                }
            
            content
        }
    }
}
