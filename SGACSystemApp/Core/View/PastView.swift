//
//  PastView.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 28.11.2024.
//

import SwiftUI

struct PastView: View {
    
    @State private var pastValue: [PastValueModel] = []
    @State private var showingPastValue: [PastValueModel] = []
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Geçmiş")
                    .foregroundColor(.white)
                    .font(.system(size: 24).bold())
                    .multilineTextAlignment(.center)
                    .padding(.top)
                Spacer()
            }
            
            ScrollView {
                ForEach(showingPastValue, id: \.id) { pastValue in
                    NavigationLink {
                        PastDetailView(title: DateFormatterHelper.dateFormatterForTabPast(with: pastValue.createdAt), pastValue: self.pastValue)
                    } label: {
                        PastTabCell(title: DateFormatterHelper.dateFormatterForTabPast(with: pastValue.createdAt))
                    }

                }
            }
            
            Spacer()
        }
        .background(Color(hex: "#232F34"))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)
        .onAppear {
            Service.getPastValues(startDate: "2024-01-01", endDate: "2024-12-31") { result in
                switch result {
                case .success(let success):
                    self.pastValue = success
                    var uniqueDates = Set<String>()
                    showingPastValue = success.filter { value in
                        let formattedDate = DateFormatterHelper.dateFormatterForTabPast(with: value.createdAt)
                        return uniqueDates.insert(formattedDate).inserted
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    PastView()
}
