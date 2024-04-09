//
//  MockHTTPTask.swift
//  PokemonGuideTests
//
//  Created by yilmaz on 15.03.2024.
//

import XCTest
import Combine
@testable import PokemonGuide

class MockHTTPTask: NetworkManagerProtocol {
    var shouldThrowError = false
    var itemsToReturn: [PokemonItem] = []
    
    func downloadWithAsync(task: HTTPTask) async throws -> [PokemonItem] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return itemsToReturn
    }
    
    func downloadWithCombine(task: HTTPTask) -> AnyPublisher<[PokemonItem], Error> {
        if shouldThrowError {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        } else {
            return Just(itemsToReturn).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
}
