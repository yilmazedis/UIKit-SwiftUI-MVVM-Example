//
//  AppScheme.swift
//  PokemonGuide
//
//  Created by yilmaz on 9.04.2024.
//

enum AppScheme: String {
    case prod = "https://gist.githubusercontent.com/DavidCorrado/"
    /// Only for demonstrating, there isn't a test url
    case qa = "https://gist.githubusercontent.com/DavidCorrado//"
}

extension AppScheme {
    /// Returns current scheme of the app
    static var current: AppScheme {
        #if PROD
            return .prod
        #else
            return .qa
        #endif
    }
}
