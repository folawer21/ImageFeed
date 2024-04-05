//
//  ProfileServiceModels.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 25.03.2024.
//

import Foundation

struct ProfileResult: Codable{
    var username: String
    var firstName: String
    var lastName: String?
    var bio: String?
    enum CodingKeys:String,CodingKey{
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}
struct Profile {
    var username: String
    var name: String
    var loginName: String
    var bio: String?
    init(username: String, firstName: String, lastName: String,bio: String?){
        self.username = username
        name = firstName + " " + lastName
        self.loginName = "@" + username
        self.bio = bio
    }
}
