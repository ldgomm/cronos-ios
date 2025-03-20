//
//  AddDomainView.swift
//  Sales
//
//  Created by José Ruiz on 9/9/24.
//

import SwiftUI

struct AddDomainView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: ProductViewModel
    
    @State private var selectedGroup: Group = Group(name: "", domains: [])
    @State private var domainName: String = ""
    @State private var subclasses: [String] = [""]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(LocalizedStringKey("group"), selection: $selectedGroup) {
                        ForEach(viewModel.groups, id: \.self) { group in
                            Text(group.name).tag(group)
                        }
                    }
                }
                
                Section(header: Text(LocalizedStringKey("domain_details"))) {
                    TextField(LocalizedStringKey("domain_name"), text: $domainName)
                    
                    ForEach(subclasses.indices, id: \.self) { index in
                        TextField(LocalizedStringKey("subclass_name"), text: $subclasses[index])
                    }
                    
                    Button(action: {
                        subclasses.append("")
                    }) {
                        Text(LocalizedStringKey("add_subclass"))
                    }
                    .padding(.top, 5)
                }
                
                Button(action: submitDomain) {
                    Text(LocalizedStringKey("submit_domain"))
                }
            }
            .navigationBarTitle(LocalizedStringKey("add_new_domain"))
            .onAppear {
                selectedGroup = viewModel.groups.first ?? Group(name: "", domains: [])
            }
        }
    }
    
    private func submitDomain() {
        let domain = Domain(name: domainName, subclasses: subclasses.map { Subclass(name: $0) })
        viewModel.postDomain(groupName: selectedGroup.name, domain: domain)
    }
}
