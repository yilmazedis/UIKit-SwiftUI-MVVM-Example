//
//  UIKitListModelView.swift
//  PokemonGuide
//
//  Created by yilmaz on 14.03.2024.
//

import Foundation
import Combine

final class ListTableViewModelView {
    
    var coordinator: ListTableViewCoordinator!

    private let httpTask: HTTPTaskProtocol
    
    init(httpTask: HTTPTaskProtocol) {
        self.httpTask = httpTask
    }
    
    func fetchPokemonItems() -> AnyPublisher<[PokemonItem], Error> {
        guard let url = URL(string: Constants.pokemonListUrl)
        else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        return httpTask.downloadWithCombine(url: url)
    }
}
