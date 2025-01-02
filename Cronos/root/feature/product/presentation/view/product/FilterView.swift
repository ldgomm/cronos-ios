//
//  FilterView.swift
//  Sales
//
//  Created by José Ruiz on 29/7/24.
//

import SwiftUI

struct FilterView: View {
    @Binding var selectedGroup: Group?
    @Binding var selectedDomain: Domain?
    @Binding var selectedSubclass: Subclass?
    var groups: [Group]
    var products: [Product]
    
    var nonEmptyGroups: [Group] {
        groups.filter { groupHasProducts($0) }
    }
    
    var nonEmptyDomains: [Domain] {
        guard let selectedGroup = selectedGroup else { return [] }
        return selectedGroup.domains.filter { domainHasProducts($0, in: selectedGroup) }
    }
    
    var nonEmptySubclasses: [Subclass] {
        guard let selectedGroup = selectedGroup, let selectedDomain = selectedDomain else { return [] }
        return selectedDomain.subclasses.filter { subclassHasProducts($0, in: selectedGroup, and: selectedDomain) }
    }
    
    private func groupHasProducts(_ group: Group) -> Bool {
        group.domains.contains { domainHasProducts($0, in: group) }
    }
    
    private func domainHasProducts(_ domain: Domain, in group: Group) -> Bool {
        domain.subclasses.contains { subclassHasProducts($0, in: group, and: domain) }
    }
    
    private func subclassHasProducts(_ subclass: Subclass, in group: Group, and domain: Domain) -> Bool {
        products.contains { product in
            product.category.group == group.name &&
            product.category.domain == domain.name &&
            product.category.subclass == subclass.name
        }
    }
    
    var body: some View {
        VStack {
            // Group Picker
            Picker(NSLocalizedString("group", comment: ""), selection: $selectedGroup) {
                Text(NSLocalizedString("all", comment: "")).tag(nil as Group?)
                ForEach(nonEmptyGroups.sorted { $0.name < $1.name }, id: \.self) { group in
                    Text(group.name).tag(group as Group?)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedGroup) { _, _ in
                selectedDomain = nil
                selectedSubclass = nil
            }
            
            // Domain Picker
            if selectedGroup != nil {
                Picker(NSLocalizedString("domain", comment: ""), selection: $selectedDomain) {
                    Text(NSLocalizedString("all", comment: "")).tag(nil as Domain?)
                    ForEach(nonEmptyDomains.sorted { $0.name < $1.name }, id: \.self) { domain in
                        Text(domain.name).tag(domain as Domain?)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: selectedDomain) { _, _ in
                    selectedSubclass = nil
                }
            }
            
            // Subclass Picker
            if selectedGroup != nil, selectedDomain != nil {
                Picker(NSLocalizedString("subclass", comment: ""), selection: $selectedSubclass) {
                    Text(NSLocalizedString("all", comment: "")).tag(nil as Subclass?)
                    ForEach(nonEmptySubclasses.sorted { $0.name < $1.name }, id: \.self) { subclass in
                        Text(subclass.name).tag(subclass as Subclass?)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        .padding(.horizontal)
    }
}
