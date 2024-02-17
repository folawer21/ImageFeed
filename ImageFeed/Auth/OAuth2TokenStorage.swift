//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 26.02.2024.
//

import Foundation

final class OAuth2TokenStorage{
    var token : String? {
        get{
            guard let token = UserDefaults.standard.string(forKey: "bearerToken") else {return nil}
            return token
        }
        set {
            UserDefaults.standard.set(newValue,forKey: "bearerToken")
        }
    }
}
