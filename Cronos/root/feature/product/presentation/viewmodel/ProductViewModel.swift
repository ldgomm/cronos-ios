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
        guard !keywords.isEmpty else {
            restoreAllProducts()
            return
        }
        
        // Decide how to split terms (example: just split by space for now).
        let terms = keywords
            .lowercased()
            .split(separator: " ")
            .map(String.init)
        
        // 1) Calculate matchCount for each product
        let productsWithMatchCount = allProducts.map { product -> (product: Product, matchCount: Int) in
            let matchCount = terms.reduce(into: 0) { count, term in
                if fieldMatches(product, term: term) {
                    count += 1
                }
            }
            return (product, matchCount)
        }
        
        // 2) Keep products that matched *all* terms
        let matchingProducts = productsWithMatchCount
            .filter { $0.matchCount == terms.count }
        
        // 3) Sort descending by matchCount (optional,
        //    but everything that remains is guaranteed to have the same matchCount anyway)
        let sortedByMatches = matchingProducts.sorted { $0.matchCount > $1.matchCount }
        
        // 4) Update your published array
        products = sortedByMatches.map { $0.product }
    }

    private func fieldMatches(_ product: Product, term: String) -> Bool {
        // Normalize term: remove spaces + lowercase
        let normalizedTerm = term
            .lowercased()
            .replacingOccurrences(of: " ", with: "")

        // Normalize product.model: remove spaces + lowercase
        let normalizedModel = product.model
            .lowercased()
            .replacingOccurrences(of: " ", with: "")

        // Only apply model search to "Ferretería"
        return product.name.lowercased().contains(term)
            || (product.label?.lowercased().contains(term) ?? false)
            || (product.owner?.lowercased().contains(term) ?? false)
            || (product.year?.lowercased().contains(term) ?? false)
            || (
                product.category.group == "Ferretería"
                && normalizedModel.contains(normalizedTerm)
            )
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
