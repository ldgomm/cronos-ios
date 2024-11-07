//
//  SettingsView.swift
//  Sales
//
//  Created by José Ruiz on 4/10/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink(destination: NoAccountDeletionView()) {
                        Label("Account Deletion", systemImage: "minus.square")
                    }
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    NavigationLink(destination: TermsOfUseView()) {
                        Label("Terms of use", systemImage: "person.fill.questionmark")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
