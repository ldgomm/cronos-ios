//
//  GetStoreByNameUseCase.swift
//  Sales
//
//  Created by José Ruiz on 24/7/24.
//

import Combine
import Foundation

class SearchStoresByNameUseCase {
    @Inject var serviceable: Serviceable

    func invoke(from url: URL) -> AnyPublisher<Result<[StoreDto], NetworkError>, Never> {
        return serviceable.getData(from: url)
    }
}
