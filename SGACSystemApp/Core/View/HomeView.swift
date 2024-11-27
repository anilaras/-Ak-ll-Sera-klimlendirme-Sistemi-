//
//  HomeView.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 25.11.2024.
//

import SwiftUI
import SwiftUICharts

struct HomeView: View {
    
    @State private var showStatisticModal: Bool = false
    
    @State private var selectedStatisticTitle: String = ""
    @State private var selectedStatisticLegend: String = "Son 7 gün"
    
    var body: some View {
        ZStack {
            mainContent
            
            if showStatisticModal {
                PopupView(close: $showStatisticModal, content: LineChartComponent(showModal: $showStatisticModal, title: selectedStatisticTitle, legend: selectedStatisticLegend))
            }
        }
        .background(Color(hex: "#232F34"))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)
    }
    
    @ViewBuilder
    private func HStackInfoCell(oneTitle: String, oneValue: String, twoTitle: String, twoValue: String, onPrimaryButtonTap: @escaping () -> Void = {}, onSecondaryButtonTap: @escaping () -> Void = {}) -> some View {
        HStack {
            
            Spacer()
            
            HomeInfoCell(title: oneTitle, value: oneValue)
                .onTapGesture {
                    onPrimaryButtonTap()
                }
            
            Spacer()
            
            HomeInfoCell(title: twoTitle, value: twoValue)
                .onTapGesture {
                    onSecondaryButtonTap()
                }
            
            Spacer()
        }
        .padding([.leading, .top, .trailing])
    }
}

#Preview {
    HomeView()
}

extension HomeView {
    private var mainContent: some View {
        VStack {
            HStack {
                Spacer()
                Text("Sera İklimlendirme Sistemi")
                    .foregroundColor(.white)
                    .font(.system(size: 24).bold())
                    .multilineTextAlignment(.center)
                    .padding(.top)
                Spacer()
            }
            
            ScrollView {
                
                HStack {
                    Text("Sera Bilgisi")
                        .foregroundColor(.white)
                        .font(.system(size: 18).bold())
                        
                    Spacer()
                }
                .padding(.leading)
                
                HStackInfoCell(oneTitle: "Toprak Nemi", oneValue: "%50", twoTitle: "Hava Basıncı", twoValue: "25 Bar", onPrimaryButtonTap: {
                    selectedStatisticTitle = "Toprak Nemi"
                    showStatisticModal = true
                }, onSecondaryButtonTap: {
                    selectedStatisticTitle = "Hava Basıncı"
                    showStatisticModal = true
                })
                
                HStackInfoCell(oneTitle: "Hava Sıcaklığı", oneValue: "24°", twoTitle: "Işık Miktarı", twoValue: "3500 Lümen", onPrimaryButtonTap: {
                    selectedStatisticTitle = "Hava Sıcaklığı"
                    showStatisticModal = true
                }, onSecondaryButtonTap: {
                    selectedStatisticTitle = "Işık Miktarı"
                    showStatisticModal = true
                })
                
                HomeInfoCell(title: "Gaz Miktarı", value: "150 PPM")
                    .onTapGesture {
                        selectedStatisticTitle = "Gaz Miktarı"
                        showStatisticModal = true
                    }
                    .padding([.leading, .trailing], 24)
                    .padding(.top)
                
            }

            
            Spacer()
        }
        .background(Color(hex: "#232F34"))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)
    }
}
