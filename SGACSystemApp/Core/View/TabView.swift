//
//  TabView.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 24.11.2024.
//

import SwiftUI

struct TabView: View {
    
    @StateObject var viewRouter = ViewRouter()

    var body: some View {
        NavigationView {
            VStack {
                switch viewRouter.currentPage {
                case .home:
                    HomeView()
                case .past:
                    PastView()
                case .settings:
                    SettingsView()
                }
                
                    
                tabView()
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(Color.backgroundColor())
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)
    }
}

#Preview {
    TabView()
}

private extension TabView {
    
    @ViewBuilder
    private func tabView() -> some View {
        HStack {
            Spacer()
            
            TabBarIcon(viewRouter: viewRouter, assignedPage: .home, imageName: "house", tabName: "Anasayfa")
            
            Spacer()
            
            TabBarIcon(viewRouter: viewRouter, assignedPage: .past, imageName: "clock", tabName: "Geçmiş")
            
            Spacer()
            
            TabBarIcon(viewRouter: viewRouter, assignedPage: .settings, imageName: "gear", tabName: "Ayarlar")
            
            Spacer()
        }
        .frame(height: 50)
        .padding([.top, .bottom])
        .padding(.bottom)
    }
}

struct TabBarIcon: View {
    
    @StateObject var viewRouter: ViewRouter
    let assignedPage: TabsPage
    
    let imageName, tabName: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            if viewRouter.currentPage == assignedPage {
                Image(systemName: imageName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color(hex: "#90EE90"))
                    .frame(width: 24,height: 24)
                
                Text(tabName)
                    .foregroundColor(Color(hex: "#90EE90"))
                    .font(.title3.bold())
                    .padding(.bottom)

            } else {
                Image(systemName: imageName)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.gray)
                    .frame(width: 24,height: 24)
                
                Text(tabName)
                    .foregroundColor(.gray)
                    .font(.title3.bold())
                    .padding(.bottom)

            }
        }
        .onTapGesture {
            viewRouter.currentPage = assignedPage
        }
    }
}
