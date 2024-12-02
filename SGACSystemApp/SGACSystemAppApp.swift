//
//  SGACSystemAppApp.swift
//  SGACSystemApp
//
//  Created by İlker Kaya on 18.11.2024.
//

import SwiftUI

@main
struct SGACSystemAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LaunchView()
        }
    }
}
