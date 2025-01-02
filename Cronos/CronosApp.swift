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
    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                ContentView()
            } else {
                AuthenticationView()
            }
        }
    }
    
    init() {
        FirebaseApp.configure()
        let _ = Singletons()
    }
}
