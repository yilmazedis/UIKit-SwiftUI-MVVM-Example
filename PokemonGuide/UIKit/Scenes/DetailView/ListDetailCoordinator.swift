//
//  ListDetailCoordinator.swift
//  PokemonGuide
//
//  Created by yilmaz on 15.03.2024.
//

import UIKit

final class ListDetailCoordinator {
    
    weak var navigator: UINavigationController?
    
    public init(navigator: UINavigationController?) {
        self.navigator = navigator
    }
    
    public func start(with item: PokemonItem) {
        let viewModel = ListDetailViewModel(coordinator: self, item: item)
        let view = ListDetailViewController(viewModel: viewModel)
        navigator?.pushViewController(view, animated: true)
    }
}
