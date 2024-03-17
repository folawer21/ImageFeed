//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 26.02.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage{
    var token : String? {
        get{
            guard let myToken = KeychainWrapper.standard.string(forKey: "bearerToken") else {
                print("Unsuccsessed token getting - token is nil")
                return nil}
            return myToken
        }
        set {
            guard let myToken = newValue else {
                KeychainWrapper.standard.removeObject(forKey: "bearerToken")
                return
            }
            let isSuccess = KeychainWrapper.standard.set(myToken, forKey: "bearerToken")
            guard isSuccess else {
                print("Unsuccsessed token saving")
                return
            }
            
        }
    }
}
