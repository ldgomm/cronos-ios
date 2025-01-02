//
//  StoreView.swift
//  Sales
//
//  Created by José Ruiz on 24/7/24.
//

import MapKit
import SwiftUI

struct StoreView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: StoreViewModel
    
    @State private var editStoreInformation: Bool = false
    
    var store: Store
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Store Image
                if let imageUrl = URL(string: store.image.url) {
                    CachedAsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 50, height: 50)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 11))
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .padding(.horizontal)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 11))
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .padding(.horizontal)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                // Address
                SectionView(title: "Address") {
                    Text("\(store.address.street), \(store.address.city), \(store.address.state) \(store.address.zipCode), \(store.address.country)")
                }
                
                Section {
                    let location2d = CLLocationCoordinate2D(latitude: store.address.location.coordinates[1], longitude: store.address.location.coordinates[0])
                    MapView(location: location2d) { _ in }
                }
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 11))
                .padding()
                
                SectionView(title: "Phone number") {
                    Text("📞 (+593) \(store.phoneNumber)")
                }
                
                SectionView(title: "Email Address") {
                    Text("✉️ \(store.emailAddress)")
                }
                
                // Website
                SectionView(title: "Website") {
                    Text(store.website)
                }
                
                Divider()
                
                SectionView(title: "Description") {
                    Text(store.description)
                }
                
                SectionView(title: "Return Policy") {
                    Text(store.returnPolicy)
                }
                
                SectionView(title: "Refund Policy") {
                    Text(store.refundPolicy)
                }
                
                SectionView(title: "Brands") {
                    Text(store.brands.joined(separator: ", "))
                }
                
                Divider()
                
                // Status
                SectionView(title: "Status") {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Status")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        statusView(status: store.status)
                            .padding(.bottom, 10)
                    }
                }
            }
            .navigationTitle(store.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        editStoreInformation.toggle()
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                }
            }
            .sheet(isPresented: $editStoreInformation) {
                EditStoreView(store: store) { newStore in
                    viewModel.removeAllStores()
                    viewModel.updateStore(newStore) { success in
                        print("View: Store updated \(success)")
                        dismiss()
                    } onFailure: { failure in
                        print("Store update failed \(failure)")
                        dismiss()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func statusView(status: Status) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if status.isActive { statusLabel(text: "Active", color: .green) }
            if status.isVerified { statusLabel(text: "Verified", color: .green) }
            if status.isPromoted { statusLabel(text: "Promoted", color: .blue) }
            if status.isSuspended { statusLabel(text: "Suspended", color: .red) }
            if status.isClosed { statusLabel(text: "Closed", color: .gray) }
            if status.isPendingApproval { statusLabel(text: "Pending Approval", color: .yellow) }
            if status.isUnderReview { statusLabel(text: "Under Review", color: .purple) }
            if status.isOutOfStock { statusLabel(text: "Out of Stock", color: .black) }
            if status.isOnSale { statusLabel(text: "On Sale", color: .pink) }
        }
    }
    
    private func statusLabel(text: String, color: Color) -> some View {
        Text(text)
            .font(.subheadline)
            .fontWeight(.bold)
            .foregroundColor(color)
    }
    
    init(store: Store) {
        self.store = store
    }
}

//struct InfoSectionView<Content: View>: View {
//    var title: String
//    var content: String?
//    var icon: String?
//    var iconColor: Color?
//    @ViewBuilder var customContent: Content
//    
//    init(title: String, content: String? = nil, icon: String? = nil, iconColor: Color? = nil, @ViewBuilder customContent: () -> Content = { EmptyView() }) {
//        self.title = title
//        self.content = content
//        self.icon = icon
//        self.iconColor = iconColor
//        self.customContent = customContent()
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            Text(title)
//                .font(.headline)
//                .foregroundColor(.secondary)
//            HStack {
//                if let icon = icon, let iconColor = iconColor {
//                    Image(systemName: icon)
//                        .foregroundColor(iconColor)
//                }
//                if let content = content {
//                    Text(content)
//                } else {
//                    customContent
//                }
//            }
//            .padding(.bottom, 10)
//        }
//    }
//}
