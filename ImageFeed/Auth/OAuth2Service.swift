//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 25.02.2024.
//

import Foundation
enum AuthServiceError: Error{
    case invalidRequest
}

final class OAuth2Service{
    
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        var  urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
        urlComponents.queryItems = [
            URLQueryItem( name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents.url else { 
            assertionFailure("Failed to create URL")
            return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        return urlRequest
    }
    
    func fetchOAuthToken(code: String, completition: @escaping (Result<String,Error>) -> Void){
        assert(Thread.isMainThread)
        guard lastCode != code else {
            completition(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = code
        guard let urlRequest = makeOAuthTokenRequest(code: code) else {
            print(11111)
            completition(.failure(AuthServiceError.invalidRequest))
            return
        }
        let task = URLSession.shared.objectTask(for: urlRequest){ [weak self] (result: Result<OAuthTokenResponseBody,Error>) in
            guard let self = self else {return }
            switch result {
            case .success(let tokenBody):
                let token = tokenBody.accessToken
                completition(.success(token))
            case .failure(let error):
                print(2222)
                completition(.failure(error))
            }
            self.task = nil
            self.lastCode = nil
        }
        task.resume()
    }
}
