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
        guard let group = selectedGroup, let domain = selectedDomain else { return [] }
        return domain.subclasses.filter { subclassHasProducts($0, in: group, and: domain) }
    }
    
    // Example checks to filter out empty categories
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
        VStack() {
            // 1) Group pills
            if !nonEmptyGroups.isEmpty {
                ScrollablePillBar(items: nonEmptyGroups.map(\.name), selected: selectedGroup?.name) { clickedGroupName in
                    if let group = groups.first(where: { $0.name == clickedGroupName }) {
                        selectedGroup = group
                        // Reset domain/subclass whenever group changes
                        selectedDomain = nil
                        selectedSubclass = nil
                    } else {
                        // "All" pill tapped
                        selectedGroup = nil
                        selectedDomain = nil
                        selectedSubclass = nil
                    }
                }
            }
            
            // 2) Domain pills (show only if a group is selected)
            if let group = selectedGroup, !nonEmptyDomains.isEmpty {
                ScrollablePillBar( items: nonEmptyDomains.map(\.name),
                    selected: selectedDomain?.name
                ) { clickedDomainName in
                    if let domain = group.domains.first(where: { $0.name == clickedDomainName }) {
                        selectedDomain = domain
                        // Reset subclass whenever domain changes
                        selectedSubclass = nil
                    } else {
                        // "All" pill tapped
                        selectedDomain = nil
                        selectedSubclass = nil
                    }
                }
            }
            
            // 3) Subclass pills (show only if group+domain selected)
            if let group = selectedGroup,
               let domain = selectedDomain,
               !nonEmptySubclasses.isEmpty
            {
                ScrollablePillBar(
                    items: nonEmptySubclasses.map(\.name),
                    selected: selectedSubclass?.name
                ) { clickedSubclassName in
                    if let subclass = domain.subclasses.first(where: { $0.name == clickedSubclassName }) {
                        selectedSubclass = subclass
                    } else {
                        // "All" pill tapped
                        selectedSubclass = nil
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}
