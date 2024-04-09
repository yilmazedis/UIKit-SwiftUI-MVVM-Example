//
//  Logger.swift
//  PokemonGuide
//
//  Created by yilmaz on 9.04.2024.
//

import Foundation

enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

final class Logger {
    private init() {}
    
    static func log(_ level: LogLevel, _ message: String..., file: String = #file, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(level.rawValue)] [\(fileName):\(line)]: \(message.joined(separator: " "))"
        print(logMessage)
        /// You can extend this method to save logs to a file or send them to a server
    }
}
