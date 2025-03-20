//
//  SpecificationView.swift
//  Sales
//
//  Created by José Ruiz on 30/5/24.
//

import SwiftUI

struct AddSpecificationsView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var colours: [String] = []
    @State private var finished: String = ""
    @State private var inBox: [String] = []
    
    @State private var width: String = ""
    @State private var height: String = ""
    @State private var depth: String = ""
    @State private var weight: String = ""
    @State private var sizeUnit: String = "mm"
    @State private var weightUnit: String = "mg"
    
    @State private var newColour: String = ""
    @State private var newInBoxItem: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let sizeUnits = ["mm", "cm", "pulgadas", "metros", "pies", "yardas"]
    let weightUnits = ["mg", "g", "libras", "kg", "onzas", "toneladas"]
    
    var specifications: Specifications?
    var popToAddEditProductView: (Specifications) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("colours", comment: "")), footer: validationMessage(for: "colours")) {
                    ForEach(colours, id: \.self) { colour in
                        Text(colour)
                    }
                    .onDelete { indexSet in
                        colours.remove(atOffsets: indexSet)
                    }
                    HStack {
                        TextField(NSLocalizedString("add_colour", comment: ""), text: $newColour)
                        Button(NSLocalizedString("add", comment: "")) {
                            if !newColour.isEmpty {
                                colours.append(newColour)
                                newColour = ""
                            }
                        }.disabled(newColour.isEmpty)
                    }
                }
                
                Section(header: Text(NSLocalizedString("in_box_items", comment: "")), footer: validationMessage(for: "inBox")) {
                    ForEach(inBox, id: \.self) { item in
                        Text(item)
                    }
                    .onDelete { indexSet in
                        inBox.remove(atOffsets: indexSet)
                    }
                    HStack {
                        TextField(NSLocalizedString("add_item", comment: ""), text: $newInBoxItem)
                        Button(NSLocalizedString("add", comment: "")) {
                            if !newInBoxItem.isEmpty {
                                inBox.append(newInBoxItem)
                                newInBoxItem = ""
                            }
                        }.disabled(newInBoxItem.isEmpty)
                    }
                }
                
                Section(header: Text(NSLocalizedString("finished", comment: "")), footer: validationMessage(for: "finished")) {
                    TextField(NSLocalizedString("finished", comment: ""), text: $finished)
                }
                
                Section {
                    TextField(NSLocalizedString("width", comment: ""), value: $width, formatter: CommaReplacingFormatter())
                        .keyboardType(.decimalPad)
                    TextField(NSLocalizedString("height", comment: ""), value: $height, formatter: CommaReplacingFormatter())
                        .keyboardType(.decimalPad)
                    TextField(NSLocalizedString("depth", comment: ""), value: $depth, formatter: CommaReplacingFormatter())
                        .keyboardType(.decimalPad)
                    Picker(NSLocalizedString("unit", comment: ""), selection: $sizeUnit) {
                        ForEach(sizeUnits, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: { Text(NSLocalizedString("size", comment: "")) } footer: { validationMessage(for: "size") }
                
                Section {
                    TextField(NSLocalizedString("weight", comment: ""), value: $weight, formatter: CommaReplacingFormatter())
                        .keyboardType(.decimalPad)
                    Picker(NSLocalizedString("unit", comment: ""), selection: $weightUnit) {
                        ForEach(weightUnits, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: { Text(NSLocalizedString("weight", comment: "")) } footer: { validationMessage(for: "weight") }
                
                Button(action: saveSpecification) {
                    Text(specifications != nil ? NSLocalizedString("update_specifications", comment: "") : NSLocalizedString("add_specifications", comment: ""))
                }.frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle(NSLocalizedString("specifications", comment: ""))
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(NSLocalizedString("validation_error", comment: "")),
                    message: Text(alertMessage),
                    dismissButton: .default(Text(NSLocalizedString("ok_button", comment: "")))
                )
            }
        }
    }
    
    init(specifications: Specifications? = nil, popToAddEditProductView: @escaping (Specifications) -> Void) {
        if let specifications {
            self.specifications = specifications
            _colours = State(wrappedValue: specifications.colours)
            _finished = State(wrappedValue: specifications.finished ?? "")
            _inBox = State(wrappedValue: specifications.inBox ?? [])
            if let size = specifications.size {
                _width = State(wrappedValue: String(size.width))
                _height = State(wrappedValue: String(size.height))
                _depth = State(wrappedValue: String(size.depth))
                _sizeUnit = State(wrappedValue: size.unit)
            }
            if let weight = specifications.weight {
                _weight = State(wrappedValue: String(weight.weight))
                _weightUnit = State(wrappedValue: weight.unit)
            }
        }
        self.popToAddEditProductView = popToAddEditProductView
    }
    
    private func saveSpecification() {
        guard !colours.isEmpty else {
            alertMessage = NSLocalizedString("add_one_colour", comment: "")
            showAlert = true
            return
        }
        
        guard !finished.isEmpty else {
            alertMessage = NSLocalizedString("finished_empty", comment: "")
            showAlert = true
            return
        }
        
        guard !inBox.isEmpty else {
            alertMessage = NSLocalizedString("add_one_item_in_box", comment: "")
            showAlert = true
            return
        }
        
        guard let widthValue = Double(width), !width.isEmpty else {
            alertMessage = NSLocalizedString("width_invalid", comment: "")
            showAlert = true
            return
        }
        
        guard let heightValue = Double(height), !height.isEmpty else {
            alertMessage = NSLocalizedString("height_invalid", comment: "")
            showAlert = true
            return
        }
        
        guard let depthValue = Double(depth), !depth.isEmpty else {
            alertMessage = NSLocalizedString("depth_invalid", comment: "")
            showAlert = true
            return
        }
        
        guard let weightValue = Double(weight), !weight.isEmpty else {
            alertMessage = NSLocalizedString("weight_invalid", comment: "")
            showAlert = true
            return
        }
        
        let size = Size(width: widthValue, height: heightValue, depth: depthValue, unit: sizeUnit)
        let weight = Weight(weight: weightValue, unit: weightUnit)
        let specifications = Specifications(colours: colours, finished: finished, inBox: inBox, size: size, weight: weight)
        print(specifications)
        popToAddEditProductView(specifications)
        dismiss()
    }
    
    private func validationMessage(for field: String) -> some View {
        let message: String
        switch field {
        case "colours":
            message = colours.isEmpty ? NSLocalizedString("add_one_colour", comment: "") : ""
        case "finished":
            message = finished.isEmpty ? NSLocalizedString("finished_empty", comment: "") : ""
        case "inBox":
            message = inBox.isEmpty ? NSLocalizedString("add_one_item_in_box", comment: "") : ""
        case "size":
            message = (width.isEmpty || height.isEmpty || depth.isEmpty) ? NSLocalizedString("all_size_fields_invalid", comment: "") : ""
        case "weight":
            message = weight.isEmpty ? NSLocalizedString("weight_invalid", comment: "") : ""
        default:
            message = ""
        }
        
        return Text(message)
            .foregroundColor(.red)
            .font(.footnote)
    }
}
