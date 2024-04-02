//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 31.03.2024.
//

import Foundation

protocol AuthHelperProtocol{
    func authRequest()-> URLRequest?
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol{
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration) {
        self.configuration = configuration
    }
    
    func code(from url: URL) -> String?{
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        }
        else{
            return nil
        }
    }
    
    func authRequest() -> URLRequest? {
        guard let url = authURL() else {return nil}
        return URLRequest(url: url)
    }
    
    func authURL() -> URL?{
        guard var urlComponents = URLComponents(string: AuthConfiguration.standart.authURLString) else{
            print("Ошибка разворачивания URLComponents ")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        return urlComponents.url
    }
}
