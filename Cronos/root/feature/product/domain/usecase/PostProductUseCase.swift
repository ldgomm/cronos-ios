//
//  PostProductsUseCase.swift
//  Sales
//
//  Created by José Ruiz on 4/4/24.
//

import Combine
import Foundation

class PostProductUseCase {
    @Inject var serviceable: Serviceable
    
    /**
     This function invokes the post data operation with the provided ProductDto to the specified URL using the injected service.
     - Parameters:
       - url: The URL to which to send data.
       - product: The ProductDto containing the data to create a new product.
     - Returns: A publisher emitting a Result type with the response data or a NetworkError.
     */
    func invoke(from url: URL, with product: PostProductRequest) -> AnyPublisher<Result<MessageResponse, NetworkError>, Never> {
        return serviceable.postData(from: url, with: product)
    }
}
