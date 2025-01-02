//
//  PutStoreInformationUseCase.swift
//  Sales
//
//  Created by José Ruiz on 24/7/24.
//

import Combine
import Foundation

class PutStoreUseCase {
    @Inject var serviceable: Serviceable

    func invoke(from url: URL, with request: PutStoreRequest) -> AnyPublisher<Result<MessageResponse, NetworkError>, Never> {
        return serviceable.putData(from: url, with: request)
    }
}
