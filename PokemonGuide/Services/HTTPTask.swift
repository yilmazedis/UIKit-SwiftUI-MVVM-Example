//
//  HTTPTask.swift
//  PokemonGuide
//
//  Created by yilmaz on 9.04.2024.
//

import Foundation

struct HTTPMethod: RawRepresentable {
    /// `CONNECT` method.
    static let connect = HTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    static let delete = HTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    static let get = HTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    static let head = HTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    static let options = HTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    static let patch = HTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    static let post = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    static let put = HTTPMethod(rawValue: "PUT")
    /// `QUERY` method.
    static let query = HTTPMethod(rawValue: "QUERY")
    /// `TRACE` method.
    static let trace = HTTPMethod(rawValue: "TRACE")

    public let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }
}

typealias Parameters = [String: Any]

protocol HTTPTask {
  var method: HTTPMethod { get }
  var body: Parameters? { get }
  var path: String { get }
}

extension HTTPTask {
    var method: HTTPMethod { return .get }
    var body: Parameters? { return nil }
}
