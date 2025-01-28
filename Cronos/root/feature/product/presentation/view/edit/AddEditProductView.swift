//
//  AddProductView.swift
//  Sales
//
//  Created by José Ruiz on 3/4/24.
//

import FirebaseStorage
import PhotosUI
import SwiftUI

struct AddEditProductView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: ProductViewModel
    
    @State private var name: String = "" //Done
    @State private var label: String? //Done
    @State private var owner: String? //Done
    @State private var year: String? //Done
    
    @State private var model: String = "" //Done
    @State private var description: String = "" //Done
    
    @State private var group: String = ""
    @State private var domain: String = ""
    @State private var subclass: String = ""
    
    @State private var selectedGroup: Group = Group(name: "", domains: [])
    @State private var selectedDomain: Domain = Domain(name: "", subclasses: [])
    @State private var selectedSubclass: Subclass = Subclass(name: "")
    
    @State private var stock: Int = 10 //Done
    
    @State private var image: UIImage? = .init(systemName: "photo")
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var oldMainImagePath: String? = ""
    @State private var oldMainImageUrl: String = ""
    @State private var mainImageHasChanged: Bool = false
    
    @State private var origin: String = "Estados Unidos" //Done
    @State private var date: Int64 = 0
    
    @State private var overview: [Information]? = []
    @State private var overviewResult: [InformationResult] = []
    @State private var addInformation: Bool = false
    
    @State private var keywords: [String] = []
    @State private var word: String = ""
    
    @State private var specifications: Specifications?
    @State private var addSpecifications: Bool = false
    
    @State private var warranty: String?
    
    @State private var legal: String? //Done
    @State private var warning: String? //Done
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @State private var informationResult: InformationResult? = nil
    @State private var updateInformationResult: Bool = false
    
    // New state variables for price, offer, and credit card
    @State private var priceAmount: String = ""
    @State private var priceCurrency: String = "USD"
    @State private var offerIsActive: Bool = true
    @State private var offerDiscount: Int = 10
    @State private var creditCardWithInterest: Int = 12
    @State private var creditCardWithoutInterest: Int = 3
    @State private var creditCardFreeMonths: Int = 0
    
    // State variables for upload progress
    @State private var uploadProgress: Double = 0.0
    @State private var isUploading = false
    
    @State private var showingGroupForm = false
    @State private var showingDomainForm = false
    @State private var showingSubclassForm = false
    
    @State private var showRequestAlert = false
    @State private var alertRequestMessage = ""
    
    var product: Product?
    var popToRoot: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    PhotosPicker(selection: $photosPickerItem, matching: .images) {
                        Image(uiImage: image ?? UIImage(systemName: "photo")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 11))
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                Section {
                    TextField(
                        NSLocalizedString("name", comment: ""),
                        text: $name,
                        prompt: Text(NSLocalizedString("name", comment: ""))
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(false)
                    
                    TextField(
                        NSLocalizedString("label", comment: ""),
                        text: Binding(
                            get: { self.label ?? "" },
                            set: { self.label = $0 }
                        ),
                        prompt: Text(NSLocalizedString("label", comment: ""))
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(false)
                    
                    TextField(
                        NSLocalizedString("owner", comment: ""),
                        text: Binding(
                            get: { self.owner ?? "" },
                            set: { self.owner = $0 }
                        ),
                        prompt: Text(NSLocalizedString("owner", comment: ""))
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(false)
                    
                    TextField(
                        NSLocalizedString("year", comment: ""),
                        text: Binding(
                            get: { self.year ?? "" },
                            set: { self.year = $0 }
                        ),
                        prompt: Text(NSLocalizedString("year", comment: ""))
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(false)
                    
                    TextField(
                        NSLocalizedString("model", comment: ""),
                        text: $model,
                        prompt: Text(NSLocalizedString("model", comment: ""))
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(false)
                    
                    TextEditor(
                        text: Binding(
                            get: { self.description },
                            set: { self.description = self.limitText($0) }
                        )
                    )
                    .frame(height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 0.5))
                    
                    Picker(NSLocalizedString("origin", comment: ""), selection: $origin) {
                        ForEach(madeIn.sorted(), id: \.self) { country in
                            Text(country)
                        }
                    }
                } header: {
                    Text(NSLocalizedString("general_information", comment: ""))
                }
                
                Section {
                    Picker(NSLocalizedString("group", comment: ""), selection: $selectedGroup) {
                        ForEach(viewModel.groups, id: \.self) { group in
                            Text(group.name).tag(group)
                        }
                    }
                    .onChange(of: selectedGroup) { _, newGroup in
                        group = newGroup.name
                        if let domainIndex = selectedGroup.domains.firstIndex(where: { $0.name == domain }) {
                            selectedDomain = selectedGroup.domains[domainIndex]
                            if let subclassIndex = selectedDomain.subclasses.firstIndex(where: { $0.name == subclass }) {
                                selectedSubclass = selectedDomain.subclasses[subclassIndex]
                            } else {
                                selectedSubclass = selectedDomain.subclasses.first ?? Subclass(name: "")
                            }
                        } else {
                            selectedDomain = newGroup.domains.first ?? Domain(name: "", subclasses: [])
                        }
                    }
                    
                    Picker(NSLocalizedString("domain", comment: ""), selection: $selectedDomain) {
                        ForEach(selectedGroup.domains, id: \.self) { domain in
                            Text(domain.name).tag(domain)
                        }
                    }
                    .onChange(of: selectedDomain) { _, newDomain in
                        domain = newDomain.name
                        if let subclassIndex = selectedDomain.subclasses.firstIndex(where: { $0.name == subclass }) {
                            selectedSubclass = selectedDomain.subclasses[subclassIndex]
                        } else {
                            selectedSubclass = newDomain.subclasses.first ?? Subclass(name: "")
                        }
                    }
                    
                    Picker(NSLocalizedString("subclass", comment: ""), selection: $selectedSubclass) {
                        ForEach(selectedDomain.subclasses, id: \.self) { subclass in
                            Text(subclass.name).tag(subclass)
                        }
                    }
                    .onChange(of: selectedSubclass) { _, newSubclass in
                        subclass = newSubclass.name
                    }
                    
                    Text("\(group) - \(domain) - \(subclass)")
                } header: {
                    Text(NSLocalizedString("category_header", comment: ""))
                } footer: {
                    Text("")
                        .font(.caption)
                        .foregroundStyle(.blue)
                        .overlay(
                            Menu {
                                Button(NSLocalizedString("add_group", comment: "")) {
                                    showingGroupForm = true
                                }
                                Button(NSLocalizedString("add_domain", comment: "")) {
                                    showingDomainForm = true
                                }
                                Button(NSLocalizedString("add_subclass", comment: "")) {
                                    showingSubclassForm = true
                                }
                            } label: {
                                Label(NSLocalizedString("options", comment: ""), systemImage: "plus")
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        )
                }
                
                // Price Section
                Section {
                    TextField(NSLocalizedString("amount", comment: ""), text: $priceAmount)
                        .keyboardType(.decimalPad)
                    Picker(NSLocalizedString("currency", comment: ""), selection: $priceCurrency) {
                        ForEach(["USD", "EUR", "GBP"], id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Toggle(NSLocalizedString("is_active", comment: ""), isOn: $offerIsActive)
                    Stepper("\(NSLocalizedString("discount", comment: "")): \(offerDiscount)%", value: $offerDiscount, in: 0...100, step: 1)
                    Stepper("\(NSLocalizedString("without_interest", comment: "")): \(creditCardWithoutInterest) months", value: $creditCardWithoutInterest, in: 0...24, step: 1)
                    Stepper("\(NSLocalizedString("with_interest", comment: "")): \(creditCardWithInterest) months", value: $creditCardWithInterest, in: 3...48, step: 1)
                    Stepper("\(NSLocalizedString("free_months", comment: "")): \(creditCardFreeMonths) months", value: $creditCardFreeMonths, in: 0...12, step: 1)
                } header: {
                    Text(NSLocalizedString("price", comment: ""))
                }
                
                Section {
                    Stepper("\(NSLocalizedString("units_of_product", comment: "")): \(stock)", value: $stock, in: 1...100, step: 1)
                } header: {
                    Text(NSLocalizedString("stock", comment: ""))
                }
                
                Section {
                    List {
                        ForEach(overviewResult.filter { !$0.isDeleted }) { informationResult in
                            InformationResultRow(informationResult: informationResult)
                        }
                        .onDelete(perform: onDeleteInformationResult)
                    }
                    Button(NSLocalizedString("add_information", comment: "")) {
                        self.addInformation.toggle()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                } header: {
                    Text(NSLocalizedString("overview", comment: ""))
                }
                
                Section {
                    Button(product != nil ? NSLocalizedString("update_specifications", comment: "") : NSLocalizedString("add_specifications", comment: "")) {
                        self.addSpecifications.toggle()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                } header: {
                    Text(NSLocalizedString("specifications", comment: ""))
                }
                
                Section(header: Text(NSLocalizedString("legal_warning_info", comment: ""))) {
                    VStack(alignment: .leading) {
                        Text(NSLocalizedString("enter_legal_information", comment: ""))
                            .font(.headline)
                        TextEditor(text: Binding(
                            get: { self.legal ?? "" },
                            set: { self.legal = self.limitText($0) }
                        ))
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 0.5))
                        
                        Text(NSLocalizedString("enter_warning_information", comment: ""))
                            .font(.headline)
                        TextEditor(text: Binding(
                            get: { self.warning ?? "" },
                            set: { self.warning = self.limitText($0) }
                        ))
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 0.5))
                        
                        Text(NSLocalizedString("warranty", comment: ""))
                            .font(.headline)
                        TextEditor(text: Binding(
                            get: { self.warranty ?? "" },
                            set: { self.warranty = self.limitText($0) }
                        ))
                        .frame(height: 100)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5), lineWidth: 0.5))
                        
                    }
                }
                
                Section {
                    Button(product != nil ? NSLocalizedString("update", comment: "") : NSLocalizedString("create", comment: "")) {
                        validateAndSaveProduct()
                    }
                    .disabled(isUploading)
                    .frame(maxWidth: .infinity, alignment: .center)
                    if isUploading {
                        ProgressView(value: uploadProgress)
                            .progressViewStyle(LinearProgressViewStyle())
                            .padding()
                        Text(NSLocalizedString("uploading", comment: ""))
                    }
                } footer: {
                    Text(product != nil ? NSLocalizedString("upload_message", comment: "") : NSLocalizedString("create_message", comment: ""))
                }
            }
            .navigationTitle(name.isEmpty ? NSLocalizedString("product", comment: "") : name)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let groupIndex = viewModel.groups.firstIndex (where: { $0.name == group }) {
                    selectedGroup = viewModel.groups[groupIndex]
                    print(selectedGroup.name)
                    if let domainIndex = selectedGroup.domains.firstIndex(where: { $0.name == domain }) {
                        selectedDomain = selectedGroup.domains[domainIndex]
                        print(selectedDomain.name)
                        if let subclassIndex = selectedDomain.subclasses.firstIndex(where: { $0.name == subclass }) {
                            selectedSubclass = selectedDomain.subclasses[subclassIndex]
                            print(selectedSubclass.name)
                        }
                    }
                }
            }
            .onAppear {
                if let oldMainImagePath {
                    downloadImage(for: oldMainImagePath)
                }
                generateOverviewResult()
            }
            .onChange(of: photosPickerItem) {
                Task {
                    if let photosPickerItem, let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            self.image = image
                            self.mainImageHasChanged = true
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("", systemImage: "arrow.backward") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        validateAndSaveProduct()
                    } label: {
                        Label(
                            product != nil ? NSLocalizedString("update", comment: "") : NSLocalizedString("create", comment: ""),
                            systemImage: "link.badge.plus"
                        )
                    }
                }
            }
            .sheet(isPresented: $addInformation) {
                AddEditInformationView { information in
                    overviewResult.append(information)
                }
            }
            .sheet(isPresented: $addSpecifications) {
                AddSpecificationsView(specifications: specifications) { newSpecifications in
                    self.specifications = newSpecifications
                }
            }
            .sheet(isPresented: $showingGroupForm) {
                AddGroupView()
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $showingDomainForm) {
                AddDomainView()
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $showingSubclassForm) {
                AddSubclassView()
                    .environmentObject(viewModel)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(NSLocalizedString("validation_error", comment: "")),
                    message: Text(alertMessage),
                    dismissButton: .default(Text(NSLocalizedString("ok_button", comment: "")))
                )
            }
        }
    }
    
    init(product: Product? = nil, popToRoot: @escaping () -> Void) {
        if let product {
            self.product = product
            _name = State(wrappedValue: product.name)
            _label = State(wrappedValue: product.label)
            _owner = State(wrappedValue: product.owner ?? "")
            _year = State(wrappedValue: product.year)
            _model = State(wrappedValue: product.model)
            _description = State(wrappedValue: product.description)
            
            _selectedGroup = State(initialValue: Group(name: product.category.group, domains: []))
            _selectedDomain = State(initialValue: Domain(name: product.category.domain, subclasses: []))
            _selectedSubclass = State(initialValue: Subclass(name: product.category.subclass))
            
            _group = State(initialValue: product.category.group)
            _domain = State(initialValue: product.category.domain)
            _subclass = State(initialValue: product.category.subclass)
            
            _stock = State(wrappedValue: product.stock)
            _origin = State(wrappedValue: product.origin)
            _date = State(wrappedValue: product.date)
            _oldMainImagePath = State(wrappedValue: product.image.path)
            _oldMainImageUrl = State(wrappedValue: product.image.url)
            _overview = State(wrappedValue: product.overview)
            _keywords = State(wrappedValue: product.keywords ?? [])
            _specifications = State(wrappedValue: product.specifications)
            _warranty = State(wrappedValue: product.warranty)
            _legal = State(wrappedValue: product.legal)
            _warning = State(wrappedValue: product.warning)
            _priceAmount = State(wrappedValue: String(product.price.amount))
            _priceCurrency = State(wrappedValue: product.price.currency)
            _offerIsActive = State(wrappedValue: product.price.offer.isActive)
            _offerDiscount = State(wrappedValue: product.price.offer.discount)
            if let creditCard = product.price.creditCard {
                _creditCardWithInterest = State(wrappedValue: creditCard.withInterest)
                _creditCardWithoutInterest = State(wrappedValue: creditCard.withoutInterest)
                _creditCardFreeMonths = State(wrappedValue: creditCard.freeMonths)
            }
        }
        self.popToRoot = popToRoot
    }
    
    private func validateAndSaveProduct() {
        guard !name.isEmpty else {
            alertMessage = NSLocalizedString("product_name_empty", comment: "")
            showAlert = true
            return
        }
        
        guard !description.isEmpty else {
            alertMessage = NSLocalizedString("product_description_empty", comment: "")
            showAlert = true
            return
        }
        
        guard !selectedGroup.name.isEmpty else {
            alertMessage = NSLocalizedString("select_group", comment: "")
            showAlert = true
            return
        }
        
        guard !selectedDomain.name.isEmpty else {
            alertMessage = NSLocalizedString("select_category", comment: "")
            showAlert = true
            return
        }
        
        guard !selectedSubclass.name.isEmpty else {
            alertMessage = NSLocalizedString("select_subcategory", comment: "")
            showAlert = true
            return
        }
        
        guard stock > 0 else {
            alertMessage = NSLocalizedString("stock_minimum", comment: "")
            showAlert = true
            return
        }
        
        guard let legal = legal, !legal.isEmpty else {
            alertMessage = NSLocalizedString("legal_info_empty", comment: "")
            showAlert = true
            return
        }
        
        guard let warning = warning, !warning.isEmpty else {
            alertMessage = NSLocalizedString("warning_info_empty", comment: "")
            showAlert = true
            return
        }
        
        guard let priceAmountValue = Double(priceAmount), !priceAmount.isEmpty else {
            alertMessage = NSLocalizedString("invalid_price_amount", comment: "")
            showAlert = true
            return
        }
        
        guard offerDiscount > 0 else {
            alertMessage = NSLocalizedString("offer_discount_invalid", comment: "")
            showAlert = true
            return
        }
        
        guard creditCardWithInterest >= 0 else {
            alertMessage = NSLocalizedString("credit_with_interest_invalid", comment: "")
            showAlert = true
            return
        }
        
        guard creditCardWithoutInterest >= 0 else {
            alertMessage = NSLocalizedString("credit_without_interest_invalid", comment: "")
            showAlert = true
            return
        }
        
        guard creditCardFreeMonths >= 0 else {
            alertMessage = NSLocalizedString("credit_free_months_invalid", comment: "")
            showAlert = true
            return
        }
        
        let price = Price(amount: priceAmountValue, currency: priceCurrency, offer: Offer(isActive: offerIsActive, discount: offerDiscount), creditCard: CreditCard(withoutInterest: creditCardWithoutInterest, withInterest: creditCardWithInterest, freeMonths: creditCardFreeMonths))
        let path = "products/main/\(UUID().uuidString).jpg"
        
        if product != nil {
            if !mainImageHasChanged {
                if let id = product?.id {
                    generateOverview { overview in
                        viewModel.putProduct(
                            product: toProduct(id: id, overview: overview, price: price)
                        ) { success in
                            self.alertRequestMessage = "Product updated successfully!"
                            self.showRequestAlert = true
                        } onFailure: { error in
                            self.alertRequestMessage = "Failed to update product: \(error)"
                            self.showRequestAlert = true
                        }
                        dismiss()
                        popToRoot()
                    }
                }
            } else {
                if let oldMainImagePath {
                    uploadNewImage(path: path, price: price)
                    if !oldMainImagePath.isEmpty {
                        deleteImageFromFirebase(for: oldMainImagePath) {
                            print("Image deleted")
                        }
                    }
                }
            }
        } else {
            uploadNewImage(path: path, price: price)
        }
    }
    
    private func uploadNewImage(path: String, price: Price) {
        guard let compressedImageData = image?.compressImage() else {
            print("Failed to compress image")
            self.alertRequestMessage = "Failed to compress image."
            self.showRequestAlert = true
            return
        }
        
        isUploading = true
        uploadImageToFirebaseWithProcessHandler(for: path, with: compressedImageData, progressHandler: { progress in
            DispatchQueue.main.async {
                self.uploadProgress = progress
            }
        }) { imageInfo in
            DispatchQueue.main.async {
                self.isUploading = false
                if let imageInfo = imageInfo {
                    if let product {
                        generateOverview { overview in
                            viewModel.putProduct(
                                product: toProduct(id: product.id, info: imageInfo, overview: overview, price: price)
                            ) { success in
                                self.alertRequestMessage = "Product updated successfully!"
                                self.showRequestAlert = true
                            } onFailure: { error in
                                self.alertRequestMessage = "Failed to update product: \(error)"
                                self.showRequestAlert = true
                            }
                            dismiss()
                            popToRoot()
                        }
                    } else {
                        generateOverview { overview in
                            viewModel.postProduct(
                                product: toProduct(info: imageInfo, overview: overview, price: price)
                            ) { success in
                                self.alertRequestMessage = "Product uploaded successfully!"
                                self.showRequestAlert = true
                            } onFailure: { error in
                                self.alertRequestMessage = "Failed to upload product: \(error)"
                                self.showRequestAlert = true
                            }
                            dismiss()
                            popToRoot()
                        }
                    }
                } else {
                    print("Failed to upload image")
                    self.alertRequestMessage = "Failed to upload image."
                    self.showRequestAlert = true
                }
            }
        }
    }
    
    
    //Post product
    private func toProduct(info imageInfo: ImageInfo, overview: [Information], price: Price) -> Product {
        return Product(id: UUID().uuidString, name: name, label: label, owner: owner, year: year, model: model, description: description, category: Category(group: group, domain: domain, subclass: subclass), price: price, stock: stock, image: ImageX(path: imageInfo.path, url: imageInfo.url, belongs: false), origin: origin, overview: overview,keywords: keywords, specifications: specifications, warranty: warranty, legal: legal, warning: warning)
    }
    
    //Put Product
    private func toProduct(id: String, overview: [Information], price: Price) -> Product {
        return Product(id: id, name: name, label: label, owner: owner, year: year, model: model, description: description, category: Category(group: group, domain: domain, subclass: subclass), price: price, stock: stock, image: ImageX(path: oldMainImagePath, url: oldMainImageUrl, belongs: false), origin: origin, date: Date().currentTimeMillis(), overview: overview, keywords: keywords, specifications: specifications, warranty: warranty, legal: legal, warning: warning)
    }
    
    //Put product
    private func toProduct(id: String, info imageInfo: ImageInfo, overview: [Information], price: Price) -> Product {
        return Product(id: id, name: name, label: label, owner: owner, year: year, model: model, description: description, category: Category(group: group, domain: domain, subclass: subclass), price: price, stock: stock, image: ImageX(path: imageInfo.path, url: imageInfo.url, belongs: false), origin: origin, date: Date().currentTimeMillis(), overview: overview, keywords: keywords, specifications: specifications, warranty: warranty, legal: legal, warning: warning)
    }
    
    func generateOverviewResult() {
        overview?.forEach { [self] result in
            if let path = result.image.path {
                let informationResult = InformationResult(id: result.id, title: result.title, subtitle: result.subtitle, description: result.description, image: nil, path: path, url: result.image.url, place: result.place, isCreated: false, isUpdated: false, isDeleted: false)
                overviewResult.append(informationResult)
            }
        }
    }
    
    func generateOverview(completion: @escaping ([Information]) -> Void) {
        var data = [Information]()
        let group = DispatchGroup()
        
        overviewResult.forEach { result in
            if !result.path.isEmpty && !result.isCreated && !result.isDeleted {
                group.enter()
                data.append(result.toInformation())
                group.leave()
            }
            
            if result.path.isEmpty && result.isCreated && !result.isDeleted {
                group.enter()
                if let image = result.image?.compressImage() {
                    let path = "products/information/\(UUID().uuidString).jpg"
                    
                    uploadImageToFirebase(for: path, with: image) { imageInfo in
                        data.append(result.toInformation(info: imageInfo))
                        group.leave()
                    }
                }
            }
            
            if !result.path.isEmpty && !result.isCreated && result.isDeleted {
                group.enter()
                deleteImageFromFirebase(for: result.path) {
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            overviewResult.removeAll { $0.isDeleted }
            completion(data)
        }
    }
    
    private func downloadImage(for path: String) {
        let reference = Storage.storage().reference(withPath: path)
        reference.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("Error: Data is nil")
                return
            }
            if let image = UIImage(data: data) {
                self.image = image
            } else {
                print("Error: Unable to convert data to UIImage")
            }
        }
    }
    
    private func onDeleteInformationResult(at offSets: IndexSet) {
        guard let index = offSets.first else { return }
        guard index >= 0 && index < overviewResult.count else { return }
        self.overviewResult[index].isDeleted = true
    }
    
    private func addKeyword() {
        if !word.isEmpty {
            //            if keywords == nil {
            //                keywords = []
            //            }
            keywords.insert(word, at: 0)
            word = ""
        }
    }
    
    private func deleteKeyword(at index: Int) {
        keywords.remove(at: index)
        //        if keywords.isEmpty == true {
        //            keywords = []
        //        }
    }
    
    private func limitText(_ text: String) -> String {
        let lines = text.components(separatedBy: .newlines)
        if lines.count > 4 {
            return lines.prefix(4).joined(separator: "\n")
        }
        
        let words = text.split(separator: " ")
        if words.count > 120 {
            return words.prefix(120).joined(separator: " ")
        }
        return text
    }
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }
}
