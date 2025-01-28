//
//  CatalogueViewModel.swift
//  Sales
//
//  Created by José Ruiz on 14/10/24.
//

import Combine
import Foundation

final class CatalogueViewModel: ObservableObject {
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
        getProductsUseCase.invoke(from: getUrl(endpoint: "cronos-catalogue"))
            .sink { (result: Result<[ProductDto], NetworkError>) in
                switch result {
                case .success(let success):
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
            from: getUrl(endpoint: "cronos-catalogue", keywords: keywords)
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
}
