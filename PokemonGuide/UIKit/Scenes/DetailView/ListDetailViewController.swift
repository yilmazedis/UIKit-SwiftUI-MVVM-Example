//
//  ListDetailViewController.swift
//  PokemonGuide
//
//  Created by yilmaz on 15.03.2024.
//

import UIKit

final class ListDetailViewController: UIViewController {
    
    private var viewModel: ListDetailViewModel!
    
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var detailLabel: UILabel!
    
    convenience init(viewModel: ListDetailViewModel) {
        self.init()
        self.viewModel = viewModel
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    private func prepareView() {
        title = viewModel.item.name
        detailLabel.text = viewModel.item.description
        posterImageView.loadWebImage(url: viewModel.item.imageUrl)
        
        detailLabel.accessibilityIdentifier = "detailLabel"
    }
}
