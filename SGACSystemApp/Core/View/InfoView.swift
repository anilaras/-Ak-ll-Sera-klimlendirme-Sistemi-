//
//  InfoView.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 2.12.2024.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "control")
                            .rotationEffect(.degrees(-90))
                        Text("Geri")
                    }
                    
                    Spacer()
                }
                .padding()
                
                Text("Hakkında")
                    .foregroundColor(.white)
                    .font(.system(size: 20).bold())
                    .multilineTextAlignment(.center)
            }
            
            ScrollView {
                InfoCell(title: "Projenin Amacı", description: """
                    Akıllı Sera İklimlendirme Sistemi Projesi, seraların iklimlendirme süreçlerini daha etkili bir şekilde yönetmek ve optimize etmek için geliştirilmiş bir mobil uygulamadır. Uygulama, seranın anlık durum bilgilerini (sıcaklık, nem, ışık seviyesi gibi) görüntüleyebilmenin yanı sıra, kullanıcıların gerekli ayarlamaları hızlı ve kolay bir şekilde yapmalarını sağlar. Ayrıca geçmiş verilere dayalı olarak detaylı istatistikler sunarak, kullanıcıların daha bilinçli kararlar almasına ve verimliliği artırmasına olanak tanır. Bu özellikler, seraların daha sürdürülebilir ve verimli bir şekilde yönetilmesine katkıda bulunur.
                    """)
                
                TechnologyCell(
                    title: "Projede Kullanılan Teknolojiler",
                    description: "Akıllı Sera İklimlendirme Sistemi, gelişmiş teknolojiler ve yazılım araçlarıyla geliştirilmiştir. Mobil uygulama kısmında Swift programlama dili kullanılmıştır. Arka uç (Backend) API geliştirme sürecinde ise PHP dili tercih edilmiştir. Veriler, Raspberry Pi ve Arduino platformları üzerindeki çeşitli sensörler kullanılarak toplanmıştır.",
                    items: [
                        "Ortam Nem Sensörü: Seranın atmosferik nem oranını ölçmek için.",
                        "Toprak Nem Sensörü: Bitki kök bölgesindeki nem seviyesini takip etmek için.",
                        "Basınç Sensörü: Ortamdaki basınç değişimlerini algılamak için.",
                        "RGB Ayarlanabilir LED: Işık renk ve yoğunluğunu kontrol etmek için.",
                        "Gaz Sensörü: Havadaki gaz miktarını (PPM biriminde) ölçmek için.",
                        "Işık Sensörü: Ortamın ışık seviyesini ölçmek için.",
                        "Kamera: Görsel veri elde etmek ve ortamı gözlemlemek için.",
                        "Sıcaklık Sensörleri: Seranın sıcaklık değişimlerini takip etmek için."
                    ]
                )
                
                VStack(spacing: 16) {
                    HStack {
                        Text("Daha detaylı bilgi için [web sitemizi](http://yesilarge.online/yesilarge) ziyaret edebilirsiniz.")
                            .foregroundColor(.white.opacity(0.9))
                            .font(.body)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                }
                .padding(20)
                .background(.ultraThinMaterial)
                .background(Color.black)
                .cornerRadius(10)
                .padding(.horizontal, 16)
                
            }
            
            Spacer()
            
            Text("© 2024 İlker Uğur Kaya")
                .foregroundColor(.gray)
                .font(.footnote)
            
        }
        .background(Color.backgroundColor())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(.stack)
    }
}

#Preview {
    InfoView()
}

struct InfoCell: View {
    
    @State var title: String
    
    @State var description: String
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(title)
                    .font(.title3.bold())
                    .foregroundColor(.white)
                Spacer()
            }
            
            Divider()
                .background(Color.white.opacity(0.6))
            
            Text(description)
                .foregroundColor(.white.opacity(0.9))
                .font(.body)
                .multilineTextAlignment(.leading)
                .lineSpacing(6)
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .background(Color.black)
        .cornerRadius(10)
        .padding(.horizontal, 16)
    }
}

struct TechnologyCell: View {
    let title: String
    let description: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.white)
            
            Divider()
                .background(Color.white.opacity(0.6))
            
            Text(description)
                .foregroundColor(.white.opacity(0.9))
                .font(.body)
                .multilineTextAlignment(.leading)
                .lineSpacing(6)
            
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                        .padding(.top, 4)
                    
                    Text(item)
                        .foregroundColor(.white.opacity(0.9))
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .background(Color.black)
        .cornerRadius(10)
        .padding(.horizontal, 16)
    }
}
