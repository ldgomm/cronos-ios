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
                
                // Section 1: Introduction
                SettingsSectionView(title: "1. Introduction", content: """
                    Welcome to Cronos, the Administrator App. This application is designed exclusively for managing enterprise-related tasks and operations within the Premier Dark Coffee ecosystem. Cronos ensures a secure and private environment for administrators, as no personal data is collected or stored.
                    """)
                
                // Section 2: No Collection of Personal Data
                SettingsSectionView(title: "2. No Collection of Personal Data", content: """
                    Our application does not collect or store any personal information from administrators. Access to the app is securely handled using API key authentication, ensuring that no names, emails, or other identifiable information are processed or retained.
                    """)
                
                // Section 3: Authentication
                SettingsSectionView(title: "3. Authentication", content: """
                    Authentication in Cronos is managed through API keys. Administrators are issued unique API keys to securely access the application. These keys are:
                    - Encrypted: API keys are securely encrypted and stored locally on the administrator’s device.
                    - Non-expiring: Keys do not expire automatically but can be manually revoked or reset if necessary.
                    - Secure: Once an administrator logs out, the API key is removed from the device to ensure security.
                    """)
                
                // Section 4: Data Usage and Security
                SettingsSectionView(title: "4. Data Usage and Security", content: """
                    While Cronos does not collect personal information, it ensures secure interactions by using industry-standard encryption protocols such as HTTPS. This guarantees that all communication between the app and the backend systems is encrypted and protected. Only authorized administrators with valid API keys can access enterprise-related data.
                    """)
                
                // Section 5: Sharing of Information
                SettingsSectionView(title: "5. Sharing of Information", content: """
                    Cronos does not share any data with third parties. As no personal data is collected or processed, there is no information to disclose. The API keys remain secure and are only used to validate access to the app’s functionality.
                    """)
                
                // Section 6: Data Security
                SettingsSectionView(title: "6. Data Security", content: """
                    Although Cronos does not store personal data, we adhere to best security practices to protect all app interactions. Encrypted communication channels and local storage for API keys ensure that only authorized administrators have access to enterprise systems and information.
                    """)
                
                // Section 7: Data Retention
                SettingsSectionView(title: "7. Data Retention", content: """
                    Cronos does not retain user sessions or store personal information. API keys are stored only during active use and are deleted when the administrator logs out or revokes access manually.
                    """)
                
                // Section 8: Privacy Rights
                SettingsSectionView(title: "8. Privacy Rights", content: """
                    As Cronos does not collect or store personal data, no data management rights are applicable to administrators. For concerns related to authentication security or API key management, please contact the enterprise support team at Premier Dark Coffee.
                    """)
                
                // Section 9: Updates to This Policy
                SettingsSectionView(title: "9. Updates to This Policy", content: """
                    This Privacy Policy may be updated periodically to reflect changes in the application or legal requirements. Updates will be communicated through internal enterprise channels. Continued use of Cronos after any updates indicates your acceptance of the revised policy.
                    """)
                
                // Section 10: Contact Information
                Text("""
                    If you have any questions or need assistance, please contact us at privacy@premierdarkcoffee.com.
                    """)
                .font(.body)
                .foregroundColor(.blue)
                
                // Section 11: Changes to This Policy
                SettingsSectionView(title: "11. Changes to This Policy", content: """
                    Any changes to this policy will take effect only when a new version of Cronos is published. This ensures that all administrators can view the updated policy natively within the app. We encourage you to keep your app updated to stay informed of any changes.
                    """)
                
                // Section 12: Response Time
                Text("""
                    Please note that while we strive to respond to all inquiries as quickly as possible, there may be times when responses take a couple of days due to operational constraints. We appreciate your patience and understanding.
                    """)
                .font(.body)
                
                // Footer
                Text("© 2024 Cronos, Premier Dark Coffee. All Rights Reserved.")
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
