//
//  PokemonItem.swift
//  PokemonGuide
//
//  Created by yilmaz on 14.03.2024.
//

import Foundation

struct PokemonItem: Codable, Hashable {
    let id: Int
    let name: String
    let description: String
    let imageUrl: URL
    
    init(id: Int, name: String, description: String, imageUrl: URL) {
        self.id = id
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        let imageUrlString = try container.decode(String.self, forKey: .imageUrl)
        
        guard let imageUrl = URL(string: imageUrlString) else {
            throw DecodingError.dataCorruptedError(forKey: .imageUrl, in: container, debugDescription: "Invalid URL string")
        }        
        self.imageUrl = imageUrl
    }
    
    static func ==(lhs: PokemonItem, rhs: PokemonItem) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static var dummy: PokemonItem {
        PokemonItem(id: 0, name: "", description: "", imageUrl: URL(string: Constants.pokemonListUrl)!)
    }
}
