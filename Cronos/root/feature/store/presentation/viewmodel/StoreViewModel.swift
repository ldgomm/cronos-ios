//
//  StoreViewModel.swift
//  Sales
//
//  Created by José Ruiz on 24/7/24.
//

import Combine
import FirebaseAuth
import Foundation

class StoreViewModel: ObservableObject {
    @Published private(set) var stores: [Store]?
    
    private var cancellables: Set<AnyCancellable> = []

    var searchStoresByNameUseCase: SearchStoresByNameUseCase = .init()
    var putStoreUseCase: PutStoreUseCase = .init()
    
    init() {
        searchStoresByName()
    }
    
    func removeAllStores() {
        self.stores?.removeAll()
        searchStoresByName()
    }
    
    func searchStoresByName(for keywords: String? = nil) {
        searchStoresByNameUseCase.invoke(from: getUrl(endpoint: "cronos-store", keywords: keywords))
            .sink { (result: Result<[StoreDto], NetworkError>) in
                switch result {
                case .success(let store):
                    self.stores = store.map { $0.toStore() }
                case .failure(let failure):
                    print("Error getting store: \(failure.localizedDescription)")
                }
            }
            .store(in: &cancellables)
    }
    
    func updateStore(_ store: StoreDto,
                     onSuccess: @escaping (String) -> Void,
                     onFailure: @escaping (String) -> Void
    ) {
        putStoreUseCase.invoke(from: getUrl(endpoint: "cronos-store"), with: PutStoreRequest(store: store))
            .sink { (result: Result<MessageResponse, NetworkError>) in
                switch result {
                case .success(let success):
                    onSuccess(success.message)
                case .failure(let failure):
                    handleNetworkFailure(failure)
                    onFailure(failure.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
}

struct MessageResponse: Codable {
    let message: String
}
