//
//  MainViewController.swift
//  PokemonGuide
//
//  Created by yilmaz on 15.03.2024.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {

    @IBOutlet weak var uiKitButton: UIButton!
    @IBOutlet weak var swiftUIButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(named: "toolbarColor")
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func prepareView() {
        // These properties can move to IBDesignable to perform into Interface Builde
        uiKitButton.setTitle("UIKit", for: .normal)
        uiKitButton.layer.borderColor = UIColor.black.cgColor
        uiKitButton.layer.borderWidth = 1
        uiKitButton.layer.cornerRadius = 5
        
        swiftUIButton.setTitle("SwiftUI", for: .normal)
        swiftUIButton.layer.borderColor = UIColor.black.cgColor
        swiftUIButton.layer.borderWidth = 1
        swiftUIButton.layer.cornerRadius = 5
    }
    
    @IBAction func uikitButtonAction(_ sender: Any) {
        ListTableViewCoordinator(navigator: navigationController).start()
    }

    @IBAction func swiftUIButtonAction(_ sender: Any) {
        let httpTask = HTTPTask()
        let vm = PokemonListViewModel(httpTask: httpTask)
        let vc = UIHostingController(rootView: PokemonList(viewModel: vm))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

