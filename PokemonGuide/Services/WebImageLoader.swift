//
//  WebImageLoader.swift
//  PokemonGuide
//
//  Created by yilmaz on 14.03.2024.
//

import UIKit
import Combine

final class WebImageLoader {
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    private func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
    
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(handleResponse)
            .eraseToAnyPublisher()
    }
    
    func downloadWithAsync() async throws -> UIImage? {
        let (data, response) = try await URLSession.shared.data(from: url)
        return handleResponse(data: data, response: response)
    }
}
