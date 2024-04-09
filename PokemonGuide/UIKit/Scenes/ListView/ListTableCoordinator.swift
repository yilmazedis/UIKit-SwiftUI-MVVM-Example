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
        let view = ListTableViewController.loadController()
        let httpTask = NetworkManager()
        view.viewModel = ListTableViewModel(coordinator: self, httpTask: httpTask)
        navigator?.pushViewController(view, animated: true)
    }
    
    func showDetail(with item: PokemonItem) {
        ListDetailCoordinator(navigator: navigator).start(with: item)
    }
}
