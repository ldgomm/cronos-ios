//
//  CronosApp.swift
//  Cronos
//
//  Created by José Ruiz on 1/11/24.
//

import Firebase
import SwiftUI

@main
struct CronosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        FirebaseApp.configure()
        let _ = Singletons()
    }
}
