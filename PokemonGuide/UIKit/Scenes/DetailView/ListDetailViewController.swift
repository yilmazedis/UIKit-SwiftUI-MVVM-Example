//
//  ListDetailViewController.swift
//  PokemonGuide
//
//  Created by yilmaz on 14.03.2024.
//

import UIKit

final class ListDetailViewController: UIViewController {
    
    var viewModel: ListDetailViewModel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ListDetailViewModel()
    }
    
    func configure(item: PokemonItem) {
        title = item.name
        detailLabel.text = item.description
        posterImageView.loadWebImage(url: item.imageUrl)
    }
}
