//
//  TermsOfUse.swift
//  Sales
//
//  Created by José Ruiz on 4/10/24.
//

import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // Section 1
                SettingsSectionView(title: "1. Introduction", content: """
                    Welcome to Sales, a private application designed for exclusive use within Premier Dark Coffee to manage administrative and enterprise-related tasks. This app is intended solely for authorized personnel and is not available to the public or external clients. Sales operates without collecting any personal data from its users.
                    """)
                
                // Section 2
                SettingsSectionView(title: "2. User Eligibility", content: """
                    The use of Sales is restricted to authorized employees and administrators of Premier Dark Coffee. Access to the app is granted via Bearer token authentication. Unauthorized access is strictly prohibited.
                    """)
                
                // Section 3
                SettingsSectionView(title: "3. Authentication", content: """
                    Authentication to Sales is handled through Bearer token authentication:
                    """)
                
                VStack(alignment: .leading) {
                    BulletPointView(content: "Bearer Authentication: Users authenticate using a secure token issued by Premier Dark Coffee's internal system, ensuring secure access without Sales storing login credentials.")
                }.padding(.horizontal, 20)
                
                SettingsSectionView(title: "4. Permitted Use", content: """
                    Users are granted limited, non-transferable rights to access and use Sales exclusively for managing enterprise tasks within Premier Dark Coffee. This includes, but is not limited to:
                    """)
                
                VStack(alignment: .leading) {
                    BulletPointView(content: "Managing internal processes.")
                    BulletPointView(content: "Accessing enterprise-related data.")
                    BulletPointView(content: "Performing administrative operations authorized by Premier Dark Coffee.")
                }.padding(.horizontal, 20)
                
                SettingsSectionView(title: "5. Confidentiality", content: """
                    As a user of Sales, you agree to maintain the confidentiality of all data and information accessed through the app. The app contains sensitive enterprise data, and users must adhere to all internal confidentiality and data protection policies of Premier Dark Coffee. Unauthorized disclosure or sharing of data accessed via Sales is strictly prohibited and may result in disciplinary action or legal consequences.
                    """)
                
                SettingsSectionView(title: "6. Data Security", content: """
                    All data interactions within Sales are secured using industry-standard encryption protocols (such as HTTPS). While we take every measure to secure the data, users are responsible for ensuring they access the app in a secure environment and do not share their authentication details with unauthorized individuals.
                    """)
                
                SettingsSectionView(title: "7. Prohibited Activities", content: """
                    Users of Sales are prohibited from engaging in the following activities:
                    """)
                
                VStack(alignment: .leading) {
                    BulletPointView(content: "Attempting to bypass security measures or gain unauthorized access to systems or data.")
                    BulletPointView(content: "Using the app for any illegal activities or purposes not authorized by Premier Dark Coffee.")
                    BulletPointView(content: "Reverse-engineering, modifying, or otherwise tampering with the Sales application.")
                }.padding(.horizontal, 20)
                
                SettingsSectionView(title: "8. Termination", content: """
                    Premier Dark Coffee reserves the right to revoke access to Sales at any time, without notice, in the event of misuse or unauthorized use. Termination of access will also occur when an employee’s association with Premier Dark Coffee ends.
                    """)
                
                SettingsSectionView(title: "9. Limitation of Liability", content: """
                    Sales is provided as-is, without any warranties. Premier Dark Coffee is not liable for any data loss, security breaches, or other damages arising from the use or inability to use the app, except where required by law.
                    """)
                
                SettingsSectionView(title: "10. Updates to Terms", content: """
                    Premier Dark Coffee may update these Terms of Use from time to time. Any changes to the terms will only take effect when a new version of the app is published, ensuring that users will be able to review the updated terms natively within the app. Continued use of the app after updates signifies acceptance of the revised terms.
                    """)
                
                // Section 4: Contact Information
                Text("""
                    If you have any questions or need assistance, please contact us at terms@premierdarkcoffee.com.
                    """)
                .font(.body)
                .foregroundColor(.blue)
                .padding(.bottom, 10)
                
                SettingsSectionView(title: "11. Delayed Response Time", content: """
                    Please note that while we strive to respond to inquiries as quickly as possible, response times may take a couple of days due to operational constraints.
                    """)
                
                // Footer
                Text("© 2024 Premier Dark Coffee. All Rights Reserved.")
                    .font(.footnote)
                    .padding(.top, 50)
            }
            .padding(.horizontal)
            .navigationTitle("Terms of Use")
        }
    }
}

#Preview {
    TermsOfUseView()
}
