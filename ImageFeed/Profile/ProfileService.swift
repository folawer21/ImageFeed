//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 03.03.2024.
//

import Foundation

enum ProfileServiceError:Error {
    case invalidRequest
}
struct ProfileResult: Codable{
    var username: String
    var firstName: String
    var lastName: String
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


final class ProfileService{
    static let shared = ProfileService()
    private(set) var profile : Profile?
    private let oAuth2TokenStorage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    private var lastToken: String?
    
    
    private init(){}
    
    private func makeURLRequest(token: String) -> URLRequest?{
        guard let url = URL(string: "https://api.unsplash.com/me") else {return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
    
    func fetchProfile(_ token:String, completion: @escaping(Result<Profile,Error>) -> Void){
        //TODO: новые ошибки
        guard lastToken != token else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastToken = token
        guard let urlRequest = makeURLRequest(token: token) else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        let task = URLSession.shared.objectTask(for: urlRequest){ [weak self] (result: Result<ProfileResult,Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let profileResult):
                let profile = Profile(username: profileResult.username, firstName: profileResult.firstName, lastName: profileResult.lastName, bio: profileResult.bio)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print(error)
            }
            self.task = nil
            self.lastToken = nil
        }
        task.resume()
    }
}
