//
//  ProductView.swift
//  Sales
//
//  Created by José Ruiz on 13/4/24.
//

import SwiftUI
import FirebaseStorage

struct ProductView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: ProductViewModel
    
    @State private var image: UIImage? = .init(systemName: "photo")
    @State private var editProduct: Bool = false
    @State private var showAlert: Bool = false
    
    let product: Product
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrl = URL(string: product.image.url) {
                    CachedAsyncImage(url: imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 50, height: 50)
                        case .success(let image):
                            ZStack(alignment: .bottomTrailing) {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity, maxHeight: 500)
                                Text(product.category.subclass)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.5))
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .padding([.trailing, .bottom], 10)
                            }
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
                
                SectionView(title: NSLocalizedString("price", comment: "")) {
                    HStack {
                        if product.price.offer.isActive {
                            Text("\(product.price.amount, format: .currency(code: product.price.currency))")
                                .font(.caption)
                                .strikethrough()
                                .foregroundColor(.secondary)
                            Spacer()
                            if product.price.offer.discount > 0 {
                                Text("\(Int(product.price.offer.discount))% OFF")
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                                    .padding(.trailing, 5)
                                let discount = Double(product.price.offer.discount) / 100.0
                                let discountedPrice = product.price.amount * (1.0 - discount)
                                Text("\(discountedPrice, format: .currency(code: product.price.currency))")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        } else {
                            Text(product.price.amount, format: .currency(code: product.price.currency))
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                SectionView(title: NSLocalizedString("label", comment: "")) {
                    Text("\(product.label ?? "")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                }
                
                if let year = product.year, let owner = product.owner {
                    SectionView(title: NSLocalizedString("owner", comment: "")) {
                        Text("\(owner), \(year)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                }
                
                if product.model.count > 3 {
                    SectionView(title: NSLocalizedString("model", comment: "")) {
                        Text("\(product.model)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                }
                
                SectionView(title: NSLocalizedString("description", comment: "")) {
                    HStack(alignment: .center) {
                        Text(product.description)
                        Spacer()
                    }
                }
                
                if !product.overview.isEmpty {
                    SectionView(title: NSLocalizedString("information", comment: "")) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(product.overview) { information in
                                    InformationCardView(information: information)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                SectionView(title: NSLocalizedString("details", comment: "")) {
                    VStack(alignment: .leading, spacing: 8) {
                        ProductDetailRow(label: NSLocalizedString("stock", comment: ""), value: "\(product.stock)")
                        ProductDetailRow(label: NSLocalizedString("origin", comment: ""), value: product.origin)
                        if let keywords = product.keywords {
                            ProductDetailRow(label: NSLocalizedString("keywords", comment: ""), value: keywords.joined(separator: ", "))
                        }
                    }
                }
                
                if let specifications = product.specifications {
                    SectionView(title: NSLocalizedString("specifications", comment: "")) {
                        VStack(alignment: .leading, spacing: 8) {
                            ProductDetailRow(label: NSLocalizedString("colours", comment: ""), value: specifications.colours.joined(separator: ", "))
                            if let finished = specifications.finished {
                                ProductDetailRow(label: NSLocalizedString("finished", comment: ""), value: finished)
                            }
                            if let inBox = specifications.inBox {
                                ProductDetailRow(label: NSLocalizedString("in_box", comment: ""), value: inBox.joined(separator: ", "))
                            }
                            if let size = specifications.size {
                                ProductDetailRow(label: NSLocalizedString("size", comment: ""), value: "\(size.width)x\(size.height)x\(size.depth) \(size.unit)")
                            }
                            if let weight = specifications.weight {
                                ProductDetailRow(label: NSLocalizedString("weight", comment: ""), value: "\(weight.weight) \(weight.unit)")
                            }
                        }
                    }
                }
                
                if let warranty = product.warranty {
                    SectionView(title: NSLocalizedString("warranty", comment: "")) {
                        ProductDetailRow(label: String(format: NSLocalizedString("for_months", comment: ""), warranty.months), value: warranty.details.joined(separator: ", "))
                    }
                }
                
                if let legal = product.legal {
                    SectionView(title: NSLocalizedString("legal", comment: "")) {
                        Text(legal)
                    }
                }
                
                if let warning = product.warning {
                    SectionView(title: NSLocalizedString("warning", comment: "")) {
                        Text(warning)
                    }
                }
                
                SectionView(title: NSLocalizedString("manage_product", comment: "")) {
                    Button {
                        showAlert = true
                    } label: {
                        Label(NSLocalizedString("delete", comment: ""), systemImage: "trash")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                }
            }
            .navigationTitle(Text(product.name))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        editProduct.toggle()
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                }
            }
            .sheet(isPresented: $editProduct) {
                AddEditProductView(product: product) {
                    dismiss()
                }
            }
            .onAppear {
                if let path = product.image.path {
                    downloadImage(for: path)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(NSLocalizedString("delete_product", comment: "")),
                    message: Text(NSLocalizedString("delete_confirmation", comment: "")),
                    primaryButton: .destructive(Text(NSLocalizedString("delete_button", comment: ""))) {
                        if let path = product.image.path, !path.isEmpty {
                            deleteImageFromFirebase(for: path) {
                                print("Main image deleted")
                            }
                        }
                        product.overview.forEach {
                            if let path = $0.image.path, !path.isEmpty {
                                deleteImageFromFirebase(for: path) {
                                    print("Information image deleted")
                                }
                            }
                        }
                        viewModel.deleteProduct(product: product) { message in
                            print("In view product deleted: \(message)")
                        } onFailure: { failure in
                            print("Failure: \(failure)")
                        }
                        dismiss()
                    },
                    secondaryButton: .cancel(Text(NSLocalizedString("cancel_button", comment: "")))
                )
            }
        }
    }
    
    private func downloadImage(for path: String) {
        let reference = Storage.storage().reference(withPath: path)
        reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            self.image = UIImage(data: data)
        }
    }
}
