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
    private let httpTask: any NetworkManagerProtocol
    
    init(httpTask: any NetworkManagerProtocol) {
        self.httpTask = httpTask
    }
    
    func fetchPokemonItems() async {
        let task = PokemonListTask()
        do {
            let items = try await httpTask.downloadWithAsync(task: task)
            self.items = items
        } catch {
            print(error.localizedDescription)
        }
    }
}
