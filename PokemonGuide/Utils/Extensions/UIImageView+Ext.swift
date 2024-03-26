//
//  UIImageView+Ext.swift
//  PokemonGuide
//
//  Created by yilmaz on 14.03.2024.
//

import UIKit

extension UIImageView {
    func loadWebImage(url: URL) {        
        Task {
            let loader = WebImageLoader(url: url)
            
            // I might handle error here, for now no need
            let image = try? await loader.downloadWithAsync()
            self.image = image
            
            // You dont need to use MainActor.run
            // Because UIImageView already run on MainActor
            // @MainActor class UIImageView : UIView
//            await MainActor.run {
//                self.image = image
//            }
        }
    }
}
