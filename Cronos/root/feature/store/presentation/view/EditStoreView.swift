//
//  EditStoreInformationView.swift
//  Sales
//
//  Created by José Ruiz on 24/7/24.
//

import FirebaseStorage
import PhotosUI
import SwiftUI

struct EditStoreView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String
    @State private var phoneNumber: String
    @State private var emailAddress: String
    @State private var website: String
    @State private var street: String
    @State private var city: String
    @State private var state: String
    @State private var zipCode: String
    @State private var country: String
    @State private var location: GeoPoint
    
    @State private var returnPolicy: String
    @State private var refundPolicy: String
    @State private var description: String
    @State private var brands: String
    
    @State private var isActive: Bool
    @State private var isVerified: Bool
    @State private var isPromoted: Bool
    @State private var isSuspended: Bool
    @State private var isClosed: Bool
    @State private var isPendingApproval: Bool
    @State private var isUnderReview: Bool
    @State private var isOutOfStock: Bool
    @State private var isOnSale: Bool
    
    @State private var image: UIImage? = .init(systemName: "photo")
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var oldMainImagePath: String? = ""
    @State private var oldMainImageUrl: String = ""
    @State private var mainImageHasChanged: Bool = false
    
    @State private var selectedCountry: Country = countries.first!
    @State private var isPhoneNumberValid: Bool = true
    
    @State private var uploadProgress: Double = 0.0
    @State private var isUploading = false
    
    var store: Store
    var popBackStack: (_ store: StoreDto) -> Void
    
    var body: some View {
        NavigationView {  //NavigationView
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
                    
                    if isUploading {
                        ProgressView(value: uploadProgress)
                            .progressViewStyle(LinearProgressViewStyle())
                            .padding()
                        Text("Uploading...")
                    }
                }
                
                Section(header: Text("Store Details")) {
                    TextField("Store Name", text: $name)
                    HStack {
                        Picker(selection: $selectedCountry) {
                            ForEach(countries) { country in
                                HStack {
                                    Text(country.flag)
                                    Text(country.code)
                                }.tag(country)
                            }
                        } label: {
                            Text("Phone number:")
                        }
                        .pickerStyle(.menu)
                        
                        TextField("Phone Number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .foregroundColor(isPhoneNumberValid ? .primary : .red)
                            .onChange(of: phoneNumber) { old, new in validatePhoneNumber(new) }
                            .padding(.leading, 8)
                    }
                    TextField("Email Address", text: $emailAddress)
                        .textInputAutocapitalization(.never)
                    TextField("Website", text: $website)
                        .textInputAutocapitalization(.never)
                }
                
                Section(header: Text("Address")) {
                    TextField("Street", text: $street)
                    TextField("City", text: $city)
                    TextField("State", text: $state)
                    TextField("Zip Code", text: $zipCode)
                    TextField("Country", text: $country)
                }
                
                Section {
                    MapView(location: CLLocationCoordinate2D(latitude: location.coordinates[1], longitude: location.coordinates[0])) { newLocation in
                        self.location = GeoPoint(type: "Point", coordinates: [newLocation.longitude, newLocation.latitude])
                    }
                }
                .frame(height: 300)
                
                Section(header: Text("Policies")) {
                    TextField("Return Policy", text: $returnPolicy)
                    TextField("Refund Policy", text: $refundPolicy)
                }
                
                Section(header: Text("Description")) {
                    TextEditor(text: $description)
                }
                
                Section(header: Text("Brands")) {
                    TextEditor(text: $brands)
                }
                
                Section(header: Text("Status")) {
                    Toggle("Active", isOn: Binding(
                        get: { isActive },
                        set: { newValue in updateStatus(isActive: newValue) }
                    ))
                    Toggle("Verified", isOn: Binding(
                        get: { isVerified },
                        set: { newValue in updateStatus(isVerified: newValue) }
                    ))
                    Toggle("Promoted", isOn: Binding(
                        get: { isPromoted },
                        set: { newValue in updateStatus(isPromoted: newValue) }
                    ))
                    Toggle("Suspended", isOn: Binding(
                        get: { isSuspended },
                        set: { newValue in updateStatus(isSuspended: newValue) }
                    ))
                    Toggle("Closed", isOn: Binding(
                        get: { isClosed },
                        set: { newValue in updateStatus(isClosed: newValue) }
                    ))
                    Toggle("Pending Approval", isOn: Binding(
                        get: { isPendingApproval },
                        set: { newValue in updateStatus(isPendingApproval: newValue) }
                    ))
                    Toggle("Under Review", isOn: Binding(
                        get: { isUnderReview },
                        set: { newValue in updateStatus(isUnderReview: newValue) }
                    ))
                    Toggle("Out of Stock", isOn: Binding(
                        get: { isOutOfStock },
                        set: { newValue in updateStatus(isOutOfStock: newValue) }
                    ))
                    Toggle("On Sale", isOn: Binding(
                        get: { isOnSale },
                        set: { newValue in updateStatus(isOnSale: newValue) }
                    ))
                }
                
            }
            .navigationBarTitle("Edit Store Information", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    if isPhoneNumberValid {
                        saveStore()
                    }
                })
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
            .onAppear {
                if let oldMainImagePath {
                    downloadImage(for: oldMainImagePath)
                }
            }
        }
    }
    
    private func validatePhoneNumber(_ number: String) {
        let pattern = selectedCountry.phoneNumberPattern
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: number.utf16.count)
        let match = regex?.firstMatch(in: number, options: [], range: range)
        
        if match != nil {
            isPhoneNumberValid = true
            print("Phone number is valid")
        } else {
            isPhoneNumberValid = false
            print("Phone number is invalid")
        }
    }
    
    private func updateStatus(isActive: Bool? = nil, isVerified: Bool? = nil, isPromoted: Bool? = nil, isSuspended: Bool? = nil, isClosed: Bool? = nil, isPendingApproval: Bool? = nil, isUnderReview: Bool? = nil, isOutOfStock: Bool? = nil, isOnSale: Bool? = nil) {
        if let isActive = isActive {
            self.isActive = isActive
            if isActive {
                self.isSuspended = false
                self.isClosed = false
            }
        }
        if let isVerified = isVerified {
            self.isVerified = isVerified
            if isVerified {
                self.isSuspended = false
                self.isPendingApproval = false
            }
        }
        if let isPromoted = isPromoted {
            self.isPromoted = isPromoted
            if isPromoted {
                self.isSuspended = false
            }
        }
        if let isSuspended {
            self.isSuspended = isSuspended
            if isSuspended {
                self.isActive = false
                self.isVerified = false
                self.isPromoted = false
                self.isPendingApproval = false
                self.isUnderReview = false
                self.isOutOfStock = false
                self.isOnSale = false
            }
        }
        if let isClosed = isClosed {
            self.isClosed = isClosed
            if isClosed {
                self.isActive = false
            }
        }
        if let isPendingApproval = isPendingApproval {
            self.isPendingApproval = isPendingApproval
            if isPendingApproval {
                self.isVerified = false
                self.isSuspended = false
            }
        }
        if let isUnderReview = isUnderReview {
            self.isUnderReview = isUnderReview
            if isUnderReview {
                self.isSuspended = false
            }
        }
        if let isOutOfStock = isOutOfStock {
            self.isOutOfStock = isOutOfStock
        }
        if let isOnSale = isOnSale {
            self.isOnSale = isOnSale
        }
    }
    
    private func saveStore() {
        if mainImageHasChanged {
            if let oldMainImagePath = oldMainImagePath {
                deleteImageFromFirebase(for: oldMainImagePath) {
                    uploadNewImage()
                }
            } else {
                uploadNewImage()
            }
        } else {
            popStore()
        }
    }
    
    private func uploadNewImage() {
        guard let compressedImageData = image?.compressImage() else {
            print("Failed to compress image")
            return
        }
        isUploading = true
        let path = "sales/stores/images/\(store.id)/profile/\(store.name).jpg"
        uploadImageToFirebaseWithProcessHandler(for: path, with: compressedImageData, progressHandler: { progress in
            DispatchQueue.main.async {
                self.uploadProgress = progress
            }
        }) { imageInfo in
            DispatchQueue.main.async {
                self.isUploading = false
                if let imageInfo = imageInfo {
                    let address = AddressDto(street: street, city: city, state: state, zipCode: zipCode, country: country, location: location.toGeoPointDto())
                    let image = ImageDto(path: imageInfo.path, url: imageInfo.url, belongs: imageInfo.belongs)
                    
                    let status = StatusDto(isActive: isActive, isVerified: isVerified, isPromoted: isPromoted, isSuspended: isSuspended, isClosed: isClosed, isPendingApproval: isPendingApproval, isUnderReview: isUnderReview, isOutOfStock: isOutOfStock, isOnSale: isOnSale)
                    
                    let store = StoreDto(id: store.id, name: name, image: image, address: address, phoneNumber: phoneNumber, emailAddress: emailAddress, website: website, description: description, returnPolicy: returnPolicy, refundPolicy: refundPolicy, brands: brands.components(separatedBy: ","), createdAt: store.createdAt, status: status)
                    
                    popBackStack(store)
                    dismiss()
                } else {
                    print("Failed to upload image")
                }
            }
        }
    }
    
    init(store: Store, popBackStack: @escaping (StoreDto) -> Void) {
        
        _name = State(wrappedValue: store.name)
        _oldMainImagePath = State(wrappedValue: store.image.path)
        _oldMainImageUrl = State(wrappedValue: store.image.url)
        
        _phoneNumber = State(wrappedValue: store.phoneNumber)
        _emailAddress = State(wrappedValue: store.emailAddress)
        _website = State(wrappedValue: store.website)
        _street = State(wrappedValue: store.address.street)
        _city = State(wrappedValue: store.address.city)
        _state = State(wrappedValue: store.address.state)
        _zipCode = State(wrappedValue: store.address.zipCode)
        _country = State(wrappedValue: store.address.country)
        _location = State(wrappedValue: store.address.location)
        
        _returnPolicy = State(wrappedValue: store.returnPolicy)
        _refundPolicy = State(wrappedValue: store.refundPolicy)
        _description = State(wrappedValue: store.description)
        _brands = State(wrappedValue: store.brands.joined(separator: ", "))
        _isActive = State(wrappedValue: store.status.isActive)
        _isVerified = State(wrappedValue: store.status.isVerified)
        _isPromoted = State(wrappedValue: store.status.isPromoted)
        _isSuspended = State(wrappedValue: store.status.isSuspended)
        _isClosed = State(wrappedValue: store.status.isClosed)
        _isPendingApproval = State(wrappedValue: store.status.isPendingApproval)
        _isUnderReview = State(wrappedValue: store.status.isUnderReview)
        _isOutOfStock = State(wrappedValue: store.status.isOutOfStock)
        _isOnSale = State(wrappedValue: store.status.isOnSale)
        self.store = store
        self.popBackStack = popBackStack
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
    
    private func popStore() {
        let address = AddressDto(street: street, city: city, state: state, zipCode: zipCode, country: country, location: location.toGeoPointDto())
        let image = ImageDto(path: oldMainImagePath ?? "", url: oldMainImageUrl, belongs: true)
        
        let status = StatusDto(isActive: isActive, isVerified: isVerified, isPromoted: isPromoted, isSuspended: isSuspended, isClosed: isClosed, isPendingApproval: isPendingApproval, isUnderReview: isUnderReview, isOutOfStock: isOutOfStock, isOnSale: isOnSale)
        
        let store = StoreDto(id: store.id, name: name, image: image, address: address, phoneNumber: phoneNumber, emailAddress: emailAddress, website: website, description: description, returnPolicy: returnPolicy, refundPolicy: refundPolicy, brands: brands.components(separatedBy: ","), createdAt: store.createdAt, status: status)
        
        popBackStack(store)
        dismiss()
    }
}

#Preview {
    EditStoreView(store: Store(
        id: "1",
        name: "iOS Store",
        image: ImageX(url: "https://example.com/store-image.jpg", belongs: false),
        address: Address(street: "123 Apple St", city: "Cupertino", state: "CA", zipCode: "95014", country: "USA",  location: GeoPoint(type: "Point", coordinates: [-122.03118, 37.33182])),
        phoneNumber: "1-800-MY-APPLE",
        emailAddress: "store@example.com",
        website: "https://apple.com",
        description: "A store that sells Apple products.",
        returnPolicy: "30-day return policy.",
        refundPolicy: "Full refund within 30 days.",
        brands: ["Apple", "Beats"], createdAt: 0,
        status: Status(isActive: true, isVerified: true, isPromoted: false, isSuspended: false, isClosed: false, isPendingApproval: false, isUnderReview: false, isOutOfStock: false, isOnSale: false)
    )) { _ in
        // Handle back stack pop
    }
}
