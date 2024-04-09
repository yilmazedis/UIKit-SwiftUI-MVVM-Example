//
//  HTTPTask.swift
//  PokemonGuide
//
//  Created by yilmaz on 14.03.2024.
//

import UIKit
import Combine

protocol NetworkManagerProtocol {
    func downloadWithCombine<T: Decodable>(task: HTTPTask) -> AnyPublisher<[T], Error>
    func downloadWithAsync<T: Decodable>(task: HTTPTask) async throws -> [T]
}

final class NetworkManager: NSObject, NetworkManagerProtocol {
    
    private let requestBuilder: any RequestBuilder
    private var session: URLSession!
    
    init(requestBuilder: any RequestBuilder = URLRequestBuilder()) {
        self.requestBuilder = requestBuilder
        super.init()
    }
    
    private func handleResponse<T: Decodable>(data: Data?, response: URLResponse?) throws -> [T] {
        invalidateSession()
        guard let data = data,
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        
        let result = try JSONDecoder().decode([T].self, from: data)
        return result
    }
    
    func downloadWithCombine<T: Decodable>(task: HTTPTask) -> AnyPublisher<[T], Error> {
        guard let request = requestBuilder.buildRequest(from: task) else {
            return Fail(error: DownloadError.failedToBuildRequest)
                .eraseToAnyPublisher()
        }
        
        prepareSession()
        return session.dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .eraseToAnyPublisher()
    }
    
    func downloadWithAsync<T: Decodable>(task: HTTPTask) async throws -> [T] {
        guard let request = requestBuilder.buildRequest(from: task) else {
            throw DownloadError.failedToBuildRequest
        }
        
        prepareSession()
        let (data, response) = try await session.data(for: request)
        return try handleResponse(data: data, response: response)
    }
    
    private func prepareSession() {
        let delegateQueue = OperationQueue()
        delegateQueue.qualityOfService = .userInteractive
        self.session = URLSession(configuration: .ephemeral, delegate: self, delegateQueue: delegateQueue)
    }
    
    // The session object keeps a strong reference to the delegate until your app exits or explicitly invalidates the session.
    // If you do not invalidate the session by calling the invalidateAndCancel() or finishTasksAndInvalidate() method,
    // your app leaks memory until it exits.
    // https://stackoverflow.com/a/49258644/7657265
    private func invalidateSession() {
        session.invalidateAndCancel()
    }
}

extension NetworkManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        // Create a server trust
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            Logger.log(.error, "Certification pinning create a server trust failed")
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Create certificate chain
        var trustCertificateChain: [SecCertificate] = []
        if #available(iOS 15.0, *) {
            trustCertificateChain = SecTrustCopyCertificateChain(serverTrust) as! [SecCertificate]
        } else {
            for index in 0..<3 {
                if let cert = SecTrustGetCertificateAtIndex(serverTrust, index) {
                    trustCertificateChain.append(cert)
                }
            }
        }
        
        // SSL policy for domain check
        let policy = SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString)
        SecTrustSetPolicies(serverTrust, policy)
        
        // Evaluate the certificate
        let isServerTrusted = SecTrustEvaluateWithError(serverTrust, nil)
        
        // Local and Remote certificate Data
        let serverCertificateDataArray = trustCertificateChain.map { SecCertificateCopyData($0) }
        
        
        // Get certificate from bundle
        guard let pathToCertificate = Bundle.main.path(forResource: "github.io", ofType: "cer"),
              let localCertificateData = NSData(contentsOfFile: pathToCertificate) else {
            Logger.log(.error, "Failed to load local certificate")
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Compare Data of both certificates
        if isServerTrusted && serverCertificateDataArray.contains(localCertificateData) {
            let credential = URLCredential(trust: serverTrust)
            Logger.log(.info, "Certification pinning is successful")
            completionHandler(.useCredential, credential)
        } else {
            Logger.log(.error, "Certification pinning is failed")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
