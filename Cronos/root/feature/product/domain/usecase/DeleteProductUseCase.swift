//
//  DeleteProductUseCase.swift
//  Sales
//
//  Created by José Ruiz on 8/5/24.
//

import Combine
import Foundation

class DeleteProductUseCase {
    @Inject var serviceable: Serviceable
    
    /**
     This function invokes the delete data operation at the specified URL using the injected service.
     - Parameter url: The URL from which to delete data.
     - Returns: A publisher emitting a Result type with the response data or a NetworkError.
     */
    func invoke(from url: URL, with request: DeleteProductRequest) -> AnyPublisher<Result<MessageResponse, NetworkError>, Never> {
        return serviceable.deleteData(from: url, with: request)
    }
}
