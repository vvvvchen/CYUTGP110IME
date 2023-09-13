//
//  CYUTGP110IMEApp.swift
//  CYUTGP110IME
//
//  Created by 朝陽資管 on 2023/9/13.
//

import SwiftUI

@main
struct CYUTGP110IMEApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
