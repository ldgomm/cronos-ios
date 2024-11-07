//
//  NoAccountDeletionView.swift
//  Sales
//
//  Created by José Ruiz on 18/10/24.
//

import SwiftUI

struct NoAccountDeletionView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Section 1: No Account Creation or Storage
                Text("""
                    The Sales application does not create or store user accounts. Administrators authenticate through third-party services like Apple and Google, without collecting or storing personal information within the Sales app itself.
                    """)
                .font(.body)
                
                // Section 2: No Need for Account Deletion
                Text("""
                    Since no personal accounts or data are stored in the Sales app, there is no need for account deletion. You can continue using the application securely without needing to manage or delete any personal data or accounts.
                    """)
                .font(.body)
                
                // Section 3: Contact Information
                Text("""
                    If you have any questions or need assistance, please contact us at deletion@premierdarkcoffee.com.
                    """)
                .font(.body)
                .foregroundColor(.blue)
                
                // Section 4: Response Time Notice
                Text("""
                    Please note that while we strive to respond to all inquiries as quickly as possible, there may be times when responses take a couple of days to be attended due to operational constraints. We appreciate your patience and understanding.
                    """)
                .font(.body)
                
                // Footer
                Text("© 2024 Sales, Premier Dark Coffee. All Rights Reserved.")
                    .font(.footnote)
                    .padding(.top, 50)
            }
            .padding()
            .navigationTitle("No Account Deletion")
        }
    }
}
