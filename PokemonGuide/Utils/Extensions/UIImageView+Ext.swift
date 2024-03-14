//
//  UIImageView+Ext.swift
//  PokemonGuide
//
//  Created by yilmaz on 14.03.2024.
//

import UIKit

extension UIImageView {
    func loadWebImage(url: String) {
        guard let url = URL(string: url) else { return }
        
        Task {
            let loader = WebImageLoader(url: url)
            let image = try? await loader.downloadWithAsync()
            await MainActor.run {
                self.image = image
            }
        }
    }
}
