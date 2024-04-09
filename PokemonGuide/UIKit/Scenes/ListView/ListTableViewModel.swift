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
    private let httpTask: any NetworkManagerProtocol
    
    init(coordinator: ListTableCoordinator, httpTask: any NetworkManagerProtocol) {
        self.httpTask = httpTask
        self.coordinator = coordinator
    }
    
    func fetchPokemonItems() -> AnyPublisher<[PokemonItem], Error> {
        let task = ListTableTask()
        return httpTask.downloadWithCombine(task: task)
    }
}
