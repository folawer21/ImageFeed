//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 25.02.2024.
//

import Foundation
final class OAuth2Service{
    
    static let shared = OAuth2Service()
    private init() {}
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
        urlComponents.queryItems = [
            URLQueryItem( name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents.url else {return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        return urlRequest
    }
    
    func fetchOAuthToken(code: String, completition: @escaping (Result<String,Error>) -> Void){
        let urlRequest = makeOAuthTokenRequest(code: code)
        guard let urlRequest = urlRequest else { return}
        let task = URLSession.shared.data(for: urlRequest){ result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    print(11111,response.access_token)
                    completition(.success(response.access_token))
                    
                } catch {
                    print(2222,error)
                    completition(.failure(error))
                    
                }
            case .failure(let error):
                print(33333,error)
                completition(.failure(error))
            }
            
        }
    }
    
}
