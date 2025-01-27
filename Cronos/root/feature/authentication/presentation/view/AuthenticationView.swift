//
//  AuthenticationView.swift
//  Cronos
//
//  Created by José Ruiz on 8/11/24.
//

import SwiftUI

struct AuthenticationView: View {
    @State private var inputText: String = ""
    @State private var isValidKey: Bool = false
    
    // Function to validate API key format
    private func validateApiKey(_ apiKey: String) -> Bool {
        if apiKey.count != 32 { return false }
        let pattern = "^[a-zA-Z0-9]{2}-[a-zA-Z0-9]{3}-[a-zA-Z0-9]{5}-[a-zA-Z0-9]{7}-[a-zA-Z0-9]{11}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: apiKey)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter your API key")
                .padding(.bottom, 8)
            
            SecureField("Enter your API key", text: $inputText, onCommit: {
                isValidKey = validateApiKey(inputText)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isValidKey ? Color.green : Color.red, lineWidth: 2)
            )
            
            //            if isValidKey {
            Button(action: {
                KeychainHelper.shared.save(inputText, forKey: "bearer")
                UserDefaults.standard.set(true, forKey: "isAuthenticated")
            }) {
                Text("Validate")
            }
            .padding()
            //            }
        }
        .padding()
    }
}

#Preview {
    AuthenticationView()
}
