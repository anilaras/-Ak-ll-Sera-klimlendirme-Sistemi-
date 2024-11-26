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
                    EmptyView()
                    Spacer()
                }
                
                    
                tabView()
            }
            .background(Color(hex: "#232F34"))
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
            
//            Spacer()
//            
//            TabBarIcon(viewRouter: viewRouter, assignedPage: .statistics, imageName: "chart.xyaxis.line", tabName: "İstatistik")
            
            Spacer()
        }
        .frame(height: 50)
        .background(Color("backgroundColor"))
        .padding([.top])
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
                    .foregroundColor(.blue)
                    .frame(width: 24,height: 24)
                
                Text(tabName)
                    .foregroundColor(.blue)
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
