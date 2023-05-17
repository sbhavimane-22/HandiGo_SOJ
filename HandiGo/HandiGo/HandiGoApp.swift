//
//  HandiGoApp.swift
//  HandiGo
//
//  Created by Shishira Bhavimane on 5/17/23.
//

import SwiftUI

@main
struct HandiGoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
