//
//  HTTPTask.swift
//  PokemonGuide
//
//  Created by yilmaz on 14.03.2024.
//

import UIKit
import Combine

protocol NetworkManagerProtocol {
    func downloadWithAsync(url: URL) async throws -> [PokemonItem]
    func downloadWithCombine(task: HTTPTask) -> AnyPublisher<[PokemonItem], Error>
}

final class NetworkManager: NetworkManagerProtocol {
    
    private let requestBuilder: RequestBuilder
    
    init(requestBuilder: RequestBuilder = URLRequestBuilder()) {
        self.requestBuilder = requestBuilder
    }
    
    private func handleResponse(data: Data?, response: URLResponse?) throws -> [PokemonItem] {
        guard let data = data,
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        let result = try JSONDecoder().decode([PokemonItem].self, from: data)
        return result
    }
    
    func downloadWithCombine(task: HTTPTask) -> AnyPublisher<[PokemonItem], Error> {
        guard let request = requestBuilder.buildRequest(from: task) else {
            return Fail(error: DownloadError.failedToBuildRequest)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .eraseToAnyPublisher()
    }
    
    func downloadWithAsync(url: URL) async throws -> [PokemonItem] {
        let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
        return try handleResponse(data: data, response: response)
    }
}
