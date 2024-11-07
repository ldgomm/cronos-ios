//
//  File.swift
//  Sales
//
//  Created by José Ruiz on 8/5/24.
//

import Combine
import Foundation

class PutProductUseCase {
    @Inject var serviceable: Serviceable
    
    /**
     This function invokes the put data operation with the provided ProductDto to the specified URL using the injected service.
     - Parameters:
       - url: The URL at which to update data.
       - product: The ProductDto containing the data to update the product.
     - Returns: A publisher emitting a Result type with the response data or a NetworkError.
     */
    func invoke(from url: URL, with request: PutProductRequest) -> AnyPublisher<Result<MessageResponse, NetworkError>, Never> {
        return serviceable.putData(from: url, with: request)
    }
}
