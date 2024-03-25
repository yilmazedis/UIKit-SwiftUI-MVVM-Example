//
//  MainViewController.swift
//  PokemonGuide
//
//  Created by yilmaz on 15.03.2024.
//

import UIKit
import SwiftUI

final class MainViewController: UIViewController {

    @IBOutlet private weak var uiKitButton: UIButton!
    @IBOutlet private weak var swiftUIButton: UIButton!
    
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateButtonBorderColor()
    }

    // UIColor.black.cgColor doesn't effect Buttons layer properties.
    // So I handle it manually
    private func updateButtonBorderColor() {
        if self.traitCollection.userInterfaceStyle == .dark {
            uiKitButton.layer.borderColor = UIColor.white.cgColor
            swiftUIButton.layer.borderColor = UIColor.white.cgColor
        } else {
            uiKitButton.layer.borderColor = UIColor.black.cgColor
            swiftUIButton.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    private func prepareView() {
        // These properties can move to IBDesignable to perform into Interface Builde
        uiKitButton.setTitle("UIKit", for: .normal)
        uiKitButton.setTitleColor(.label, for: .normal)
        uiKitButton.layer.borderColor = UIColor.black.cgColor
        uiKitButton.layer.borderWidth = 1
        uiKitButton.layer.cornerRadius = 5
        uiKitButton.accessibilityIdentifier = "uiKitButton"
        
        swiftUIButton.setTitle("SwiftUI", for: .normal)
        swiftUIButton.setTitleColor(.label, for: .normal)
        swiftUIButton.layer.borderColor = UIColor.black.cgColor
        swiftUIButton.layer.borderWidth = 1
        swiftUIButton.layer.cornerRadius = 5
        swiftUIButton.accessibilityIdentifier = "swiftUIButton"
    }
    
    @IBAction private func uikitButtonAction(_ sender: Any) {
        ListTableCoordinator(navigator: navigationController).start()
    }

    @IBAction private func swiftUIButtonAction(_ sender: Any) {
        let httpTask = HTTPTask()
        let vm = PokemonListViewModel(httpTask: httpTask)
        let vc = UIHostingController(rootView: PokemonListView(viewModel: vm))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

