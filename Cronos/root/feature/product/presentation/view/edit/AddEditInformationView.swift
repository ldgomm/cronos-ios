//
//  AddInformationView.swift
//  Sales
//
//  Created by José Ruiz on 8/5/24.
//

import FirebaseStorage
import PhotosUI
import SwiftUI

struct AddEditInformationView: View {
    @Environment(\.dismiss) var dismiss
    
    //    @Binding var informationResult: InformationResult?
    private var popToAddEditProductView: (InformationResult) -> Void
    
    @State private var title: String = ""
    @State private var subtitle: String = ""
    @State private var description: String = ""
    @State private var image: UIImage? = .init(systemName: "photo")
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    if let image {
                        PhotosPicker(selection: $photosPickerItem, matching: .images) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 11))
                                .frame(maxWidth: .infinity, maxHeight: 300)
                                .padding(.horizontal)
                        }
                    }
                }
                Section {
                    TextField(NSLocalizedString("title", comment: ""), text: $title)
                } footer: {
                    validationMessage(for: "title")
                }
                Section {
                    TextField(NSLocalizedString("subtitle", comment: ""), text: $subtitle)
                } footer: {
                    validationMessage(for: "subtitle")
                }
                Section {
                    TextField(NSLocalizedString("description", comment: ""), text: $description)
                } footer: {
                    validationMessage(for: "description")
                }
                
                Button(NSLocalizedString("add_information", comment: "")) {
                    saveInformation()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle(NSLocalizedString("add_info_navigation_title", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: photosPickerItem) {
            Task {
                if let photosPickerItem, let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        self.image = image
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(NSLocalizedString("validation_error", comment: "")),
                message: Text(alertMessage),
                dismissButton: .default(Text(NSLocalizedString("ok_button", comment: "")))
            )
        }
    }
    
    init(popToAddEditProductView: @escaping (InformationResult) -> Void) {
        self.popToAddEditProductView = popToAddEditProductView
    }
    
    private func saveInformation() {
        if validateFields() {
            let information = InformationResult(title: title, subtitle: subtitle, description: description, image: image, path: "", url: "", place: 0, isCreated: true, isUpdated: false, isDeleted: false)
            print("INFORMATION RESULT: \(information)")
            popToAddEditProductView(information)
            
            dismiss()
        }
    }
    
    private func validateFields() -> Bool {
        if title.isEmpty {
            alertMessage = NSLocalizedString("title_empty", comment: "")
            showAlert = true
            return false
        }
        
        if subtitle.isEmpty {
            alertMessage = NSLocalizedString("subtitle_empty", comment: "")
            showAlert = true
            return false
        }
        
        if description.isEmpty {
            alertMessage = NSLocalizedString("description_empty", comment: "")
            showAlert = true
            return false
        }
        
        return true
    }
    
    private func validationMessage(for field: String) -> some View {
        let message: LocalizedStringKey
        switch field {
        case "title":
            message = title.isEmpty ? LocalizedStringKey("title_empty") : LocalizedStringKey("")
        case "subtitle":
            message = subtitle.isEmpty ? LocalizedStringKey("subtitle_empty") : LocalizedStringKey("")
        case "description":
            message = description.isEmpty ? LocalizedStringKey("description_empty") : LocalizedStringKey("")
        default:
            message = LocalizedStringKey("")
        }
        
        return Text(message)
            .foregroundColor(.red)
            .font(.footnote)
    }
}
