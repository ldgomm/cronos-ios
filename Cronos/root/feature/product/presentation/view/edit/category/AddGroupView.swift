//
//  AddGroupView.swift
//  Sales
//
//  Created by José Ruiz on 9/9/24.
//

import SwiftUI

struct AddGroupView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: ProductViewModel
    
    @State private var groupName: String = ""
    @State private var domains: [DomainInput] = [DomainInput()]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(LocalizedStringKey("group_details"))) {
                    TextField(LocalizedStringKey("group_name"), text: $groupName)
                }

                Section(header: Text(LocalizedStringKey("domains"))) {
                    ForEach(domains.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            TextField("", text: $domains[index].name) // No se repite "domain_name"

                            ForEach(domains[index].subclasses.indices, id: \.self) { subclassIndex in
                                TextField("", text: $domains[index].subclasses[subclassIndex]) // No se repite "subclass_name"
                            }

                            Button(action: {
                                domains[index].subclasses.append("")
                            }) {
                                Text("") // No se repite "add_subclass"
                            }
                            .padding(.top, 5)
                        }
                        .padding(.vertical, 5)
                    }

                    Button(action: {
                        domains.append(DomainInput())
                    }) {
                        Text(LocalizedStringKey("add_domain"))
                    }
                }

                Button(action: submitGroup) {
                    Text(LocalizedStringKey("submit_group"))
                }
            }
            .navigationBarTitle(LocalizedStringKey("add_new_group"))
        }
    }

    private func submitGroup() {
        let group = Group(name: groupName, domains: domains.map { Domain(name: $0.name, subclasses: $0.subclasses.map { Subclass(name: $0) }) })
        viewModel.postGroup(group: group)
        dismiss()
    }
}

struct DomainInput {
    var name: String = ""
    var subclasses: [String] = [""]
}
