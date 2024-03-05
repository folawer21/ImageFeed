//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 03.03.2024.
//

import Foundation

struct UserResult: Codable{
    var profileImage: [String]
    
    enum CodingKeys:String,CodingKey{
        case profileImage = "profile_image"
    }
}

final class ProfileImageService{
    static let shared = ProfileImageService()
    private let tokenStorage = OAuth2TokenStorage()
    private(set) var avatarURL: String?
    private var task: URLSessionTask?
    private var lastUsername: String?
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    
    
    private init(){}
    
    private func makeURLRequest(username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/:\(username)") else {return nil}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        guard let token = tokenStorage.token else {return nil}
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return urlRequest
        
    }
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String,Error>) -> Void){
        guard lastUsername != username else {
            //TODO: новые ошибки
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastUsername = username
        guard let urlRequest = makeURLRequest(username: username) else {
            completion(.failure(ProfileServiceError.invalidRequest))
            return
        }
        
        let task = URLSession.shared.objectTask(for: urlRequest){ [weak self] (result: Result<UserResult,Error>) in
            guard let self = self else {return}
            switch result{
            case .success(let userResult):
                let smallPhotoURL = userResult.profileImage[0]
                self.avatarURL = smallPhotoURL
                completion(.success(smallPhotoURL))
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": smallPhotoURL])
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
            self.lastUsername = nil
        }
        task.resume()
    }
}
