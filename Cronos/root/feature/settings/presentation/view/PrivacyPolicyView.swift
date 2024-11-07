//
//  PrivacyPolicyView.swift
//  Sales
//
//  Created by José Ruiz on 4/10/24.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Section 1
                SettingsSectionView(title: "1. Introduction", content: """
                    Welcome to Sales. This is a private application designed exclusively for administrative purposes within the enterprise. Sales does not collect customer data and is not intended for public use. This Privacy Policy outlines the handling of authentication and security within the app, ensuring privacy for administrators who access it.
                    """)
                
                // Section 2
                SettingsSectionView(title: "2. Information We Collect", content: """
                    Sales does not collect personal data directly from users.
                    """)
                
                // Section 3
                SettingsSectionView(title: "3. Authentication", content: """
                    Authentication to Sales is handled through Bearer token authentication
                    """)
                
                // Additional sections
                SettingsSectionView(title: "4. Data Usage and Security", content: """
                    Sales does not collect, store, or process personal information about its administrators beyond the authentication token required for login verification. Any enterprise-related data accessed or managed within the app remains strictly within the enterprise systems and is not processed or stored by Sales.
                    """)
                
                SettingsSectionView(title: "5. Sharing of Your Information", content: """
                    As Sales does not collect or process any personal data, there is no information shared with third parties. Authentication details remain within the confines of Apple’s and Google’s secure login systems.
                    """)
                
                SettingsSectionView(title: "6. Data Security", content: """
                    Although no personal data is collected, we use encryption protocols (such as HTTPS) for all communications between the app and our backend systems to ensure the security of all interactions. Access to enterprise data within Sales is managed securely, ensuring that only authorized administrators have access.
                    """)
                
                SettingsSectionView(title: "7. Data Retention", content: """
                    As Sales does not store user data or sessions, there is no retention of personal information. Authentication tokens are used only during active use and are discarded once the session ends.
                    """)
                
                SettingsSectionView(title: "8. Privacy Rights", content: """
                    Since no personal data is collected or stored, administrators have no data-related rights to manage within Sales. Authentication is handled entirely by third-party services (Apple and Google), and any concerns regarding authentication privacy should be directed to those services.
                    """)
                
                SettingsSectionView(title: "9. Updates to This Policy", content: """
                    This Privacy Policy may be updated from time to time. You will be notified of any changes via internal communication within the enterprise. Continued use of Sales following any updates signifies your acceptance of the revised policy.
                    """)
                
                // Section 3: Contact Information
                Text("""
                        If you have any questions or need assistance, please contact us at privacy@premierdarkcoffee.com.
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
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 30)
            }
            .padding(.horizontal)
            .navigationTitle(Text("Privacy Policy"))
        }
    }
}

#Preview {
    PrivacyPolicyView()
}
