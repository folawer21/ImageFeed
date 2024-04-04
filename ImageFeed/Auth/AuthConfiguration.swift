//
//  Constants.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 23.02.2024.
//

import Foundation

enum Constants{
    static let accessKey = "W222z7fyUGHqSCByRZJPutRfREuVa50J5RJFbhexn7Q";
    static let secretKey = "OmU7u-wv8iDsf90zAUJ4Q7JCIwiAsA7OoZMbqFrAV3M";
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob";
    static let accessScope = "public+read_user+write_likes";
    static let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    
//
//    static let accessKey = "Q-pM9VMhOzOVE_l35jdcwC2HopBklHme4fiGB5f7mCo";
//    static let secretKey = "PzY6cBpeRA6MSCjLUESIc8YBql-nM8EDL_z7WDuv5kY";
//    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob";
//    static let accessScope = "public+read_user+write_likes";
//    static let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
//    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration{
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope:String
    let defaultBaseURL: URL
    let authURLString: String
    static var standart: AuthConfiguration{
        return AuthConfiguration(accessKey: Constants.accessKey, secretKey: Constants.secretKey, redirectURI: Constants.redirectURI, accessScope: Constants.accessScope, defaultBaseURL: Constants.DefaultBaseURL, authURLString: Constants.unsplashAuthorizeURLString)
    }
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
