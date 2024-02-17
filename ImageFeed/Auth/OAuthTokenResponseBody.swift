//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 26.02.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    var access_token: String
    init(access_token: String) {
        self.access_token = access_token
    }
}
