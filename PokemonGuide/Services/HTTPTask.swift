//
//  HTTPTask.swift
//  PokemonGuide
//
//  Created by yilmaz on 14.03.2024.
//

import UIKit
import Combine

class HTTPTask {
    static let shared = HTTPTask()
    
    private func handleResponse(data: Data?, response: URLResponse?) throws -> [PokemonItem] {
        guard let data = data,
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        do {
            let result = try JSONDecoder().decode([PokemonItem].self, from: data)
            return result
        } catch {
            throw error
        }
    }
    
    func downloadWithEscaping(url: URL, completionHandler: @escaping (_ items: [PokemonItem]?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            do {
                let items = try self?.handleResponse(data: data, response: response)
                completionHandler(items, nil)
            } catch {
                completionHandler(nil, error)
            }
            
        }
        .resume()
    }
    
    func downloadWithCombine(url: URL) -> AnyPublisher<[PokemonItem]?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(handleResponse)
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
    
    func downloadWithAsync(url: URL) async throws -> [PokemonItem]? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            return try handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
}