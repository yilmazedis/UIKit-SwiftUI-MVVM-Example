//
//  UIKitListModelView.swift
//  PokemonGuide
//
//  Created by yilmaz on 14.03.2024.
//

import Foundation
import Combine

final class ListTableViewModel {
    
    let coordinator: ListTableCoordinator
    private let httpTask: HTTPTaskProtocol
    @Published var items: [PokemonItem] = []
    
    init(coordinator: ListTableCoordinator, httpTask: HTTPTaskProtocol) {
        self.httpTask = httpTask
        self.coordinator = coordinator
    }
    
    func fetchPokemonItems() -> AnyPublisher<[PokemonItem], Error> {
        guard let url = URL(string: Constants.pokemonListUrl)
        else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        return httpTask.downloadWithCombine(url: url)
    }
}
