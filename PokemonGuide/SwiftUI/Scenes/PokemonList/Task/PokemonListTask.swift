//
//  PokemonListTask.swift
//  PokemonGuide
//
//  Created by yilmaz on 9.04.2024.
//

final class PokemonListTask: HTTPTask {
    var method: HTTPMethod
    var path: String
    
    init() {
        path = "8912aa29d7c4a5fbf03993b32916d601/raw"
        method = .get
    }
}
