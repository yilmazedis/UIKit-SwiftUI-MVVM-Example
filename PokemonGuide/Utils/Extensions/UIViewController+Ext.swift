//
//  UIViewController+Ext.swift
//  PokemonGuide
//
//  Created by yilmaz on 15.03.2024.
//

import UIKit

extension UIViewController {
    // Make sure xib file name and your controller name exact match
    static func loadController() -> Self {
        Self(nibName: "\(self)", bundle: nil)
    }
}
