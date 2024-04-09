//
//  DownloadError.swift
//  PokemonGuide
//
//  Created by yilmaz on 9.04.2024.
//

import Foundation

enum DownloadError: LocalizedError {
    case failedToBuildRequest
    
    var errorDescription: String? {
        switch self {
        case .failedToBuildRequest:
            return NSLocalizedString("Failed to build request", comment: "")
        }
    }
}
