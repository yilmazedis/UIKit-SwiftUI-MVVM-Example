//
//  ListDetailViewModel.swift
//  PokemonGuide
//
//  Created by yilmaz on 14.03.2024.
//

import Foundation

final class ListDetailViewModel {
    let coordinator: ListDetailCoordinator
    var item: PokemonItem
    
    init(coordinator: ListDetailCoordinator, item: PokemonItem) {
        self.coordinator = coordinator
        self.item = item
    }
}
