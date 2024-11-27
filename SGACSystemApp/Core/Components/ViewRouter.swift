//
//  ViewRouter.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 24.11.2024.
//

import Foundation

class ViewRouter: ObservableObject {
    @Published var currentPage: TabsPage = .home
}

enum TabsPage {
    case home
    case past
    case settings
}
