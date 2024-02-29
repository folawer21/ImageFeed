//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 26.02.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    var accessToken: String
    var tokenType: String
    var scope: String
    var createdAt: String
    init(accessToken: String,tokenType: String, scope: String,createdAt:String) {
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.scope = scope
        self.createdAt = createdAt
    }
}
