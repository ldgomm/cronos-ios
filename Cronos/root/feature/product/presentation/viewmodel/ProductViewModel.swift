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
        getCategories()
    }
    
    /**
     This function retrieves all products from the server.
     */
    func getProducts() {
        getProductsUseCase.invoke(from: getUrl(endpoint: "cronos-products"))
            .sink { (result: Result<[ProductDto], NetworkError>) in
                switch result {
                case .success(let success):
                    success.filter { $0.category.group == "Licores" }
                     .sorted {
                     if $0.label == $1.label {
                     return $0.name < $1.name
                     }
                     return $0.label ?? "" < $1.label ?? ""
                     }
                     .forEach { product in
                     print("\(product.name) - \(product.label ?? "") - \(product.owner ?? "")")
                     }
                    
                    self.products = success.map { $0.toProduct() }
                case .failure(let failure):
                    handleNetworkFailure(failure)
                }
            }.store(in: &cancellables)
    }
    
    /**
     This function retrieves a product from the server using its keywords.
     - Parameter keywords: The keywords of the product to retrieve.
     */
    func getProductByKeywords(for keywords: String) {
        print("Keywords called")
        guard !keywords.isEmpty else {
            getProducts()
            return
        }
        getProductByKeywordsUseCase.invoke(
            from: getUrl(endpoint: "cronos-products", keywords: keywords)
        )
        .sink { (result: Result<[ProductDto], NetworkError>) in
            switch result {
            case .success(let success):
                print("Matches: \(success.count)")
                self.products = success.map { $0.toProduct() }
            case .failure(let failure):
                handleNetworkFailure(failure)
            }
        }
        .store(in: &cancellables)
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
