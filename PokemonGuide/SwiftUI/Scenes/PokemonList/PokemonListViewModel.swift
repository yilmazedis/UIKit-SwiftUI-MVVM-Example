//
//  PokemonListViewModel.swift
//  PokemonGuide
//
//  Created by yilmaz on 15.03.2024.
//

import SwiftUI

@MainActor
final class PokemonListViewModel: ObservableObject {
    @Published var items: [PokemonItem] = []
    private let httpTask: NetworkManagerProtocol
    
    init(httpTask: NetworkManagerProtocol) {
        self.httpTask = httpTask
    }
    
    func fetchPokemonItems() async {
        guard let url = URL(string: Constants.pokemonListUrl) else { return }
        do {
            let items = try await httpTask.downloadWithAsync(url: url)
            self.items = items
        } catch {
            print(error.localizedDescription)
        }
    }
}
