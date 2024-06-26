//
//  PokemonDetailViewModel.swift
//  PokemonGuide
//
//  Created by yilmaz on 19.03.2024.
//

import SwiftUI

class PokemonDetailViewModel: ObservableObject {
    @Published var image: UIImage?
    let item: PokemonItem
    
    init(item: PokemonItem) {
        self.item = item
    }
    
    func fetchImage() async {        
        let image = try? await WebImageLoader(url: item.imageUrl).downloadWithAsync()
        await MainActor.run {
            self.image = image
        }
    }
}
