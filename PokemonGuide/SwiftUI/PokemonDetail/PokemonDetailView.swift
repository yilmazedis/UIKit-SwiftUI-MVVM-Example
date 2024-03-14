//
//  PokemonDetailView.swift
//  PokemonGuide
//
//  Created by yilmaz on 14.03.2024.
//

import SwiftUI

struct PokemonDetailView: View {
    
    let item: PokemonItem
    
    @State private var image: UIImage?
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
            }
            
            ScrollView {
                Text(item.description)
            }
        }
        .navigationTitle(item.name)
        .toolbarBackground(
            Color("toolbarColor"),
            for: .navigationBar
        )
        .toolbarBackground(.visible, for: .navigationBar)
        .task {
            guard let url = URL(string: item.imageUrl) else { return }
            
            let image = try? await WebImageLoader(url: url).downloadWithAsync()
            await MainActor.run {
                self.image = image
            }
        }
    }
}

#Preview {
    PokemonDetailView(item: PokemonItem(id: 1,
                                     name: "Bulbasaur",
                                     description: "There is a plant seed on its back right from the day this Pokémon is born. The seed slowly grows larger.",
                                     imageUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png"))
}
