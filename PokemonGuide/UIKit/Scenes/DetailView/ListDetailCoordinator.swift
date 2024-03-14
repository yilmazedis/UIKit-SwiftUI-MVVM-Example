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
        let view = ListDetailViewController(nibName: "ListDetailViewController", bundle: nil)
        view.item = item
        view.viewModel = ListDetailViewModel()
        view.viewModel.coordinator = self
        
        navigator?.pushViewController(view, animated: true)
    }
}
