//
//  ListTableViewCoordinator.swift
//  PokemonGuide
//
//  Created by yilmaz on 15.03.2024.
//

import UIKit

final class ListTableViewCoordinator {
    
    weak var navigator: UINavigationController?
    
    public init(navigator: UINavigationController?) {
        self.navigator = navigator
    }
    
    public func start() {
        let view = ListTableViewController.loadController()
        view.viewModel = ListTableViewModelView(httpTask: HTTPTask())
        view.viewModel.coordinator = self
        
        navigator?.pushViewController(view, animated: true)
    }
    
    func showDetail(with item: PokemonItem) {
        ListDetailCoordinator(navigator: navigator).start(with: item)
    }
}
