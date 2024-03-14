//
//  MainViewController.swift
//  PokemonGuide
//
//  Created by yilmaz on 13.03.2024.
//

import UIKit
import SwiftUI

extension UIViewController {
    static func loadController() -> Self {
        guard let identifier = "\(self)".components(separatedBy: "Controller").first else {
            preconditionFailure("Unable to initialize view controller with name: \(self)")
        }
        
        let nib = UINib(nibName: identifier, bundle:nil)
        
        guard let vc = nib.instantiate(withOwner: self, options: nil).first as? Self else {
            preconditionFailure("Unable to initialize view controller with name: \(self)")
        }
        return vc
    }
}

class MainViewController: UIViewController {

    @IBOutlet weak var uiKitButton: UIButton!
    @IBOutlet weak var swiftUIButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        
        let vc = ListTableViewController.loadController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func swiftUIButtonAction(_ sender: Any) {
        let vc = UIHostingController(rootView: PokemonList())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

