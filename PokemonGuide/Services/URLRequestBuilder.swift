//
//  URLRequestBuilder.swift
//  PokemonGuide
//
//  Created by yilmaz on 9.04.2024.
//

import Foundation

protocol RequestBuilder {
    func buildRequest(from task: HTTPTask) -> URLRequest?
}

struct URLRequestBuilder: RequestBuilder {
//    private var baseURL = AppScheme.current.rawValue
    private var baseURL = Constants.pokemonListBaseUrl
    
    init() {}
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func buildRequest(from task: HTTPTask) -> URLRequest? {
        guard let url = URL(string: baseURL + task.path) else {
            Logger.log(.warning, "guard let fail")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = task.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.setValue("Basic JEcYcEM......Vc3G2JtVjNZbWx1", forHTTPHeaderField: "Authorization")
        
        if let body = task.body {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: body)
                request.httpBody = jsonData
            } catch {
                return nil
            }
        }
        
        return request
    }
}
