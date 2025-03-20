//
//  ProductViewModel.swift
//  Sales
//
//  Created by José Ruiz on 3/4/24.
//

import Combine
import Foundation

final class ProductViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var catalogueProducts: [Product] = []
    private var allProducts: [Product] = []
    
    @Published var groups: [Group] = []
    
    private var cancellables: Set<AnyCancellable> = []
    
    let getProductsUseCase: GetProductsUseCase = .init()
    let getProductByKeywordsUseCase: GetProductByKeywordsUseCase = .init()
    let postProductUseCase: PostProductUseCase = .init()
    let putProductUseCase: PutProductUseCase = .init()
    let deleteProductUseCase: DeleteProductUseCase = .init()
    
    let getGroupsUseCase: GetGroupsUseCase = .init()
    let postGroupUseCase: PostGroupUseCase = .init()
    let postDomainUseCase: PostDomainUseCase = .init()
    let postSubclassUseCase: PostSubclassUseCase = .init()
    
    init() {
        getProducts()
        getCatalogueProducts()
        getCategories()
    }
    
    //                    success.filter { $0.category.group == "Licores" }
    //                     .sorted {
    //                     if $0.label == $1.label {
    //                         return $0.name < $1.name
    //                     }
    //                         return $0.label ?? "" < $1.label ?? ""
    //                     }
    //                     .forEach { product in
    //                         print("\(product.name) - \(product.label ?? "") - \(product.owner ?? "")")
    //                     }
 
    func getProducts() {
        getProductsUseCase.invoke(from: getUrl(endpoint: "cronos-products"))
            .sink { (result: Result<[ProductDto], NetworkError>) in
                switch result {
                case .success(let success):
                    let loadedProducts = success.map { $0.toProduct() }
                    self.allProducts = loadedProducts
                    self.products = loadedProducts
                case .failure(let failure):
                    handleNetworkFailure(failure)
                }
            }
            .store(in: &cancellables)
    }
    
    /*
     func getProducts() {
        getProductsUseCase.invoke(from: getUrl(endpoint: "cronos-products"))
            .sink { (result: Result<[ProductDto], NetworkError>) in
                switch result {
                case .success(let success):
                    
                    // 1) Filter out products whose model is "N/A"
                    let filteredSuccess = success.filter { $0.model != "N/A" }
                    
                    // 2) Group by the product's category.group
                    let productsByGroup = Dictionary(grouping: filteredSuccess) { $0.category.group }
                    
                    // We'll collect exactly *one* representative of each duplicate
                    var singleRepresentativesOfDuplicates: [ProductDto] = []
                    
                    // 3) For each group, group by normalized model, detect duplicates
                    for (_, productsInGroup) in productsByGroup {
                        
                        // Group by "normalized" model
                        let groupedByModel = Dictionary(grouping: productsInGroup) {
                            $0.model.lowercased().replacingOccurrences(of: " ", with: "")
                        }
                        
                        // 4) Filter down to only those that have more than 1 product (duplicates)
                        let duplicates = groupedByModel.filter { $1.count > 1 }
                        
                        // 5) From each duplicate set, just pick the *first* item as a representative
                        //    (could also pick .first(where: ...) or any other logic you prefer)
                        for (_, duplicateItems) in duplicates {
                            if let representative = duplicateItems.first {
                                singleRepresentativesOfDuplicates.append(representative)
                            }
                        }
                    }
                    
                    // 6) Convert your single representatives to domain models (if needed)
                    let loadedProducts = singleRepresentativesOfDuplicates.map { $0.toProduct() }
                    
                    // 7) Assign them to your ViewModel’s properties
                    //    so your app/UI only shows *one row* per repeated model.
                    self.allProducts = loadedProducts
                    self.products = loadedProducts
                    
                    // 8) Print them, if you like
                    if loadedProducts.isEmpty {
                        print("No repeated models found (ignoring \"N/A\").")
                    } else {
                        print("Showing one representative for each repeated model:")
                        for product in singleRepresentativesOfDuplicates {
                            print("  \(product.name), group: \(product.category.group), model: \(product.model)")
                        }
                    }
                    
                case .failure(let failure):
                    handleNetworkFailure(failure)
                }
            }
            .store(in: &cancellables)
    }
     */

    func getCatalogueProducts() {
        getProductsUseCase.invoke(from: getUrl(endpoint: "cronos-catalogue"))
            .sink { (result: Result<[ProductDto], NetworkError>) in
                switch result {
                case .success(let success):
                    self.catalogueProducts = success.map { $0.toProduct() }
                case .failure(let failure):
                    handleNetworkFailure(failure)
                }
            }
            .store(in: &cancellables)
    }
    
    func getProductByKeywords(for keywords: String) {
        let trimmed = keywords.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 1) If there's no input, restore the full list
        guard !trimmed.isEmpty else {
            restoreAllProducts()
            return
        }
        
        // 2) Single-term if search starts with a digit, otherwise split
        let firstCharIsDigit = trimmed.first?.isNumber ?? false
        let terms: [String]
        if firstCharIsDigit {
            // Keep entire string as one term
            terms = [trimmed.lowercased()]
        } else {
            // Split on spaces
            terms = trimmed
                .lowercased()
                .split(separator: " ")
                .map(String.init)
        }
        
        // 3) Compute how many terms each product matches
        let productsWithMatchCount = allProducts.map { product -> (product: Product, matchCount: Int) in
            let matchCount = terms.reduce(into: 0) { count, term in
                if fieldMatches(product, term: term) {
                    count += 1
                }
            }
            return (product, matchCount)
        }
        
        // 4) Filter products that match *all* terms (matchCount == terms.count)
        let matchingProducts = productsWithMatchCount
            .filter { $0.matchCount == terms.count }
        
        // 5) Sort descending by match count (optional — everything has the same count anyway)
        let sortedByMatches = matchingProducts.sorted { $0.matchCount > $1.matchCount }
        
        // 6) Update the published array
        products = sortedByMatches.map { $0.product }
    }

    // MARK: - fieldMatches

    /// Returns `true` if `product` matches the given `term`
    /// in *any* of the following fields:
    ///  - `name`, `label`, `owner`, `year` (case-insensitive substring),
    ///  - `model` (with spaces removed, also case-insensitive).
    private func fieldMatches(_ product: Product, term: String) -> Bool {
        let lowerTerm = term.lowercased()
        
        // 1) Check name, label, owner, year with normal substring matching
        let basicFields = [
            product.name.lowercased(),
            product.label?.lowercased() ?? "",
            product.owner?.lowercased() ?? "",
            product.year?.lowercased() ?? ""
        ]
        
        if basicFields.contains(where: { $0.contains(lowerTerm) }) {
            return true
        }
        
        // 2) Check the model, removing spaces from both
        let normalizedModel = product.model
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
        
        let normalizedTerm = lowerTerm
            .replacingOccurrences(of: " ", with: "")
        
        return normalizedModel.contains(normalizedTerm)
    }


    func restoreAllProducts() {
        products = allProducts
    }
    
    /**
     This function creates a new product on the server using the provided Product object.
     - Parameter product: The Product object to create.
     */
    func postProduct(
        product: Product,
        onSuccess: @escaping (String) -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        postProductUseCase.invoke(
            from: getUrl(endpoint: "cronos-products"),
            with: PostProductRequest(product: product.toProductDto())
        )
        .sink { (result: Result<MessageResponse, NetworkError>) in
            switch result {
            case .success(let data):
                onSuccess(data.message)
            case .failure(let failure):
                onFailure(failure.localizedDescription)
                handleNetworkFailure(failure)
            }
        }
        .store(in: &cancellables)
    }
    
    /**
     This function updates a product on the server using the provided Product object.
     - Parameter product: The Product object to update.
     */
    func putProduct(
        product: Product,
        onSuccess: @escaping (String) -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        putProductUseCase.invoke(
            from: getUrl(endpoint: "cronos-products"),
            with: PutProductRequest(product: product.toProductDto())
        )
        .sink { (result: Result<MessageResponse, NetworkError>) in
            switch result {
            case .success(let success):
                print("ViewModel putProduct response name: \(success.message)")
            case .failure(let failure):
                handleNetworkFailure(failure)
            }
        }
        .store(in: &cancellables)
    }
    
    /**
     This function deletes a product from the server using its ID.
     - Parameter id: The ID of the product to delete.
     */
    func deleteProduct(
        product: Product,
        onSuccess: @escaping (String) -> Void,
        onFailure: @escaping (String) -> Void
    ) {
        deleteProductUseCase.invoke(
            from: getUrl(endpoint: "cronos-products"),
            with: DeleteProductRequest(productId: product.id))
        .sink { (result: Result<MessageResponse, NetworkError>) in
            switch result {
            case .success(let success):
                print(success.message)
                onSuccess(success.message)
            case .failure(let failure):
                onFailure(failure.localizedDescription)
                handleNetworkFailure(failure)
            }
        }
        .store(in: &cancellables)
    }
    
    func getCategories() {
        groups.removeAll()
        getGroupsUseCase.invoke(from: getUrl(endpoint: "data/groups"))
            .sink { (result: Result<[Group], NetworkError>) in
                switch result {
                case .success(let success):
                    self.groups = success
                case .failure(let failure):
                    handleNetworkFailure(failure)
                }
            }
            .store(in: &cancellables)
    }
    
    func postGroup(group: Group) {
        groups.removeAll()
        postGroupUseCase.invoke(
            from: getUrl(endpoint: "data/groups"),
            with: PostGroupRequest(group: group))
        .sink { (result: Result<Group, NetworkError>) in
            switch result {
            case .success(let success):
                print(success)
                self.getCategories()
            case .failure(let failure):
                handleNetworkFailure(failure)
            }
        }
        .store(in: &cancellables)
    }
    
    func postDomain(groupName: String ,domain: Domain) {
        groups.removeAll()
        postDomainUseCase.invoke(
            from: getUrl( endpoint: "data/groups/domains"),
            with: PostDomainRequest(groupName: groupName, domain: domain))
        .sink { (result: Result<Domain, NetworkError>) in
            switch result {
            case .success(let success):
                print(success)
                self.getCategories()
            case .failure(let failure):
                handleNetworkFailure(failure)
            }
        }
        .store(in: &cancellables)
    }
    
    func postSubclass(groupName: String, domainName: String, subclass: Subclass) {
        groups.removeAll()
        postSubclassUseCase.invoke(
            from: getUrl(endpoint: "data/groups/subclasses"),
            with: PostSubclassRequest(groupName: groupName, domainName: domainName, subclass: subclass))
        .sink { (result: Result<Subclass, NetworkError>) in
            switch result {
            case .success(let success):
                print(success)
                self.getCategories()
            case .failure(let failure):
                handleNetworkFailure(failure)
            }
        }
        .store(in: &cancellables)
    }
}
