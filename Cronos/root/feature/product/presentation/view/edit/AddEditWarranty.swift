//
//  AddEditWarranty.swift
//  Sales
//
//  Created by José Ruiz on 30/5/24.
//

import SwiftUI

struct AddEditWarranty: View {
    @Environment(\.dismiss) var dismiss

    @State private var hasWarranty: Bool = false
    @State private var details: [String] = []
    @State private var months: Int = 0
    @State private var detailInput: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var warranty: Warranty?
    var popToAddEditProductView: (Warranty) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("warranty_status", comment: ""))) {
                    Toggle(isOn: $hasWarranty) {
                        Text(NSLocalizedString("has_warranty", comment: ""))
                    }
                }
                
                if hasWarranty {
                    Section(header: Text(NSLocalizedString("warranty_details", comment: "")), footer: validationMessage(for: "details")) {
                        HStack {
                            TextField(NSLocalizedString("enter_detail", comment: ""), text: $detailInput)
                            Button {
                                if !detailInput.isEmpty {
                                    details.append(detailInput)
                                    detailInput = ""
                                }
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                        List {
                            ForEach(details, id: \.self) { detail in
                                Text(detail)
                            }
                            .onDelete { indexSet in
                                details.remove(atOffsets: indexSet)
                            }
                        }
                    }
                    
                    Section(header: Text(NSLocalizedString("warranty_duration", comment: "")), footer: validationMessage(for: "months")) {
                        Stepper(value: $months, in: 0...120) {
                            Text("\(months) \(NSLocalizedString("months", comment: ""))")
                        }
                    }
                }
                
                Button(warranty != nil ? NSLocalizedString("update_warranty", comment: "") : NSLocalizedString("add_warranty", comment: "")) {
                    validateAndSaveWarranty()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationBarTitle(NSLocalizedString("add_new_warranty_specification", comment: ""), displayMode: .inline)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(NSLocalizedString("validation_error", comment: "")),
                    message: Text(alertMessage),
                    dismissButton: .default(Text(NSLocalizedString("ok_button", comment: "")))
                )
            }
        }
    }

    private func validateAndSaveWarranty() {
        guard !hasWarranty || validateFields() else { return }

        let warranty = Warranty(hasWarranty: hasWarranty, details: hasWarranty ? details : [], months: hasWarranty ? months : 0)
        popToAddEditProductView(warranty)
        dismiss()
    }

    private func validateFields() -> Bool {
        if details.isEmpty {
            alertMessage = NSLocalizedString("add_warranty_detail", comment: "")
            showAlert = true
            return false
        }

        if months == 0 {
            alertMessage = NSLocalizedString("warranty_duration_invalid", comment: "")
            showAlert = true
            return false
        }

        return true
    }

    private func validationMessage(for field: String) -> some View {
        let message: String
        switch field {
        case "details":
            message = details.isEmpty ? NSLocalizedString("add_warranty_detail", comment: "") : ""
        case "months":
            message = months == 0 ? NSLocalizedString("warranty_duration_invalid", comment: "") : ""
        default:
            message = ""
        }
        
        return Text(message)
            .foregroundColor(.red)
            .font(.footnote)
    }
}
