//
//  HTTPTask.swift
//  PokemonGuide
//
//  Created by yilmaz on 14.03.2024.
//

import UIKit
import Combine
import CommonCrypto

protocol NetworkManagerProtocol {
    func downloadWithCombine<T: Decodable>(task: HTTPTask) -> AnyPublisher<[T], Error>
    func downloadWithAsync<T: Decodable>(task: HTTPTask) async throws -> [T]
}

final class NetworkManager: NSObject, NetworkManagerProtocol {
    
    private let requestBuilder: RequestBuilder
    private let publicKeyManager: PublicKeyManagerProtocol
        
    init(requestBuilder: RequestBuilder = URLRequestBuilder(),
         publicKeyManager: PublicKeyManagerProtocol = PublicKeyManager()) {
        self.requestBuilder = requestBuilder
        self.publicKeyManager = publicKeyManager
        super.init()
    }
    
    private func handleResponse<T: Decodable>(data: Data?, response: URLResponse?) throws -> [T] {
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
        
        let session = prepareSession()
        return session.dataTaskPublisher(for: request)
            .tryMap(handleResponse)
            .handleEvents(receiveCompletion: { _ in session.invalidateAndCancel() })
            .eraseToAnyPublisher()
    }
    
    func downloadWithAsync<T: Decodable>(task: HTTPTask) async throws -> [T] {
        guard let request = requestBuilder.buildRequest(from: task) else {
            throw DownloadError.failedToBuildRequest
        }
        
        let session = prepareSession()
        let (data, response) = try await session.data(for: request)
        defer { session.invalidateAndCancel() }
        return try handleResponse(data: data, response: response)
    }
    
    // The session object keeps a strong reference to the delegate until your app exits or explicitly invalidates the session.
    // If you do not invalidate the session by calling the invalidateAndCancel() or finishTasksAndInvalidate() method,
    // your app leaks memory until it exits.
    // https://stackoverflow.com/a/49258644/7657265
    private func prepareSession() -> URLSession {
        let delegateQueue = OperationQueue()
        delegateQueue.qualityOfService = .userInteractive
        return URLSession(configuration: .ephemeral, delegate: self, delegateQueue: delegateQueue)
    }
}

// MARK: - URLSessionDelegate

extension NetworkManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        // Create a server trust
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            print("Challenge did not contain server trust.")
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        
        // Retrieve certificate chain
        var certificate: SecCertificate?
        
        if #available(iOS 15.0, *) {
            guard let certificateChain = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate],
                  let firstCertificate = certificateChain.first else {
                print("Failed to retrieve certificate chain.")
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            certificate = firstCertificate
        } else {
            certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)
        }
        
        guard let certificate = certificate else {
            print("Failed to retrieve server certificate.")
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Extract server public key
        guard let serverPublicKey = SecCertificateCopyKey(certificate),
              let serverPublicKeyData = SecKeyCopyExternalRepresentation(serverPublicKey, nil) else {
            print("Failed to extract server public key.")
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        let publicKeyData: Data = serverPublicKeyData as Data
        
        // Verify the server's public key against the local public key
        if publicKeyManager.verify(publicKeyData) {
            let credential: URLCredential = URLCredential(trust: serverTrust)
            print("Public Key pinning is successful")
            completionHandler(.useCredential, credential)
        } else {
            print("Public Key pinning failed: Server public key does not match expected key.")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
        
        // Uncomment below for Certificate Pinning
        /*
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
         */
    }
}
