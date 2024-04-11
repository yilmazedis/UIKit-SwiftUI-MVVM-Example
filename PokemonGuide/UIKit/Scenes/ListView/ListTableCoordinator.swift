//
//  ListTableViewCoordinator.swift
//  PokemonGuide
//
//  Created by yilmaz on 15.03.2024.
//

import UIKit

final class ListTableCoordinator {
    
    weak var navigator: UINavigationController?
    
    public init(navigator: UINavigationController?) {
        self.navigator = navigator
    }
    
    public func start() {
        let httpTask = NetworkManager()
        let viewModel = ListTableViewModel(coordinator: self, httpTask: httpTask)
        let view = ListTableViewController(viewModel: viewModel)
        navigator?.pushViewController(view, animated: true)
    }
    
    func showDetail(with item: PokemonItem) {
        ListDetailCoordinator(navigator: navigator).start(with: item)
    }
}
