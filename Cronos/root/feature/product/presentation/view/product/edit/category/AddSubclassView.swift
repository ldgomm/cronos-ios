//
//  AddSubclass.swift
//  Sales
//
//  Created by José Ruiz on 9/9/24.
//

import SwiftUI

struct AddSubclassView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: ProductViewModel
    
    @State private var selectedGroup: Group = Group(name: "", domains: [])
    @State private var selectedDomain: Domain = Domain(name: "", subclasses: [])
    @State private var subclassName: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(LocalizedStringKey("group"), selection: $selectedGroup) {
                        ForEach(viewModel.groups, id: \.self) { group in
                            Text(group.name).tag(group)
                        }
                    }
                    .onChange(of: selectedGroup) { _, newGroup in
                        selectedDomain = newGroup.domains.first ?? Domain(name: "", subclasses: [])
                    }
                    
                    Picker("", selection: $selectedDomain) { // No se repite "Domain"
                        ForEach(selectedGroup.domains, id: \.self) { domain in
                            Text(domain.name).tag(domain)
                        }
                    }
                }
                
                Section(header: Text(LocalizedStringKey("subclass_details"))) {
                    TextField("", text: $subclassName) // No se repite "Subclass Name"
                }
                
                Button(action: submitSubclass) {
                    Text(LocalizedStringKey("submit_subclass"))
                }
                .frame(maxWidth: .infinity)
                .disabled(selectedGroup.name.isEmpty || selectedDomain.name.isEmpty || subclassName.isEmpty)
            }
            .navigationBarTitle(LocalizedStringKey("add_new_subclass"))
            .onAppear {
                selectedGroup = viewModel.groups.first ?? Group(name: "", domains: [])
                selectedDomain = selectedGroup.domains.first ?? Domain(name: "", subclasses: [])
            }
        }
    }
    
    
    private func submitSubclass() {
        let subclass = Subclass(name: subclassName)
        viewModel.postSubclass(groupName: selectedGroup.name, domainName: selectedDomain.name, subclass: subclass)
        dismiss()
    }
}
