//
//  UIKitListModelView.swift
//  PokemonGuide
//
//  Created by yilmaz on 14.03.2024.
//

import Foundation
import Combine

final class ListTableViewModelView {        
    func fetchPokemonItems() -> AnyPublisher<[PokemonItem], Error> {
        guard let url = URL(string: Constants.pokemonListUrl)
        else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        return downloadWithCombine(url: url)
    }
    
    func downloadWithCombine(url: URL) -> AnyPublisher<[PokemonItem], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(handleResponse)
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
    
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
}
