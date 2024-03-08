//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 03.03.2024.
//

import Foundation

enum ProfileImageServiceError:Error {
    case invalidRequest
}
struct UserResult: Codable{
    var profileImage: [String: String]
    
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
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {return nil}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        guard let token = tokenStorage.token else {return nil}
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String,Error>) -> Void){
        guard lastUsername != username else {
            print("[fetchProfileImageURL]: ProfileImageServiceError - lastUsername == username ")
            completion(.failure(ProfileImageServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastUsername = username
        guard let urlRequest = makeURLRequest(username: username) else {
            print("[fetchProfileImageURL]: ProfileImageServiceError - invalidRequest")
            completion(.failure(ProfileImageServiceError.invalidRequest))
            return
        }
        let task = URLSession.shared.objectTask(for: urlRequest){ [weak self] (result: Result<UserResult,Error>) in
            guard let self = self else {return}
            switch result{
            case .success(let userResult):
                guard let smallPhotoURL = userResult.profileImage["small"] else {return }
                self.avatarURL = smallPhotoURL
                completion(.success(smallPhotoURL))
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": smallPhotoURL])
            case .failure(let error):
                print("[fetchProfileImageURL]: ProfileImageServiceError - \(error)")
                completion(.failure(error))
            }
            self.task = nil
            self.lastUsername = nil
        }
        task.resume()
    }
}
