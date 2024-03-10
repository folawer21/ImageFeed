//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 10.03.2024.
//

import Foundation
struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResultList: Codable{
    var listPhotos: [PhotoResult]
}
struct PhotoResult: Codable{
    var id: String
    var width: Int
    var height: Int
    var createdAt: Date?
    var welcomeDescription: String?
    var isLiked: Bool
    var urls: [String: String]
    enum CodingKeys: String,CodingKey{
        case id = "id"
        case width = "width"
        case height = "height"
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
        case urls = "urls"
    }
}
struct UrlResult{
    var full: String
    var thumb: String
}

final class ImageListService{
    private var lastLoadedPage: Int?
    private (set) var photos: [Photo] = []
    private var task: URLSessionTask?
    private let tokenStorage = OAuth2TokenStorage()
    private let perPage = 10
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func makePhotosRequest(token: String,page: Int) -> URLRequest?{
        var urlComponents = URLComponents(string: "https://api.unsplash.com/photos")
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ]
        guard let url = urlComponents?.url else {return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return urlRequest
        
    }
    
    func fetchPhotosNextPage(){
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let token = tokenStorage.token else {return }
        if var task = task { return }
        guard let request = makePhotosRequest(token: token, page: nextPage) else {return}
        //NOTE: Не парсятся данные скорее всего нужно  вызвать не objectTask потом развернуть или как-то декрдировать правильно потому что ругается на декодированте
        let task = URLSession.shared.objectTask(for: request){ [weak self ] (result: Result<PhotoResultList,Error>) in
            guard let self = self else {return}
            var newPhotos: [Photo] = []
            switch result{
            case .success(let photoResults):
                for photoResult in photoResults.listPhotos{
                    let urls = photoResult.urls
                    guard let full = urls["full"], let thumb = urls["thumb"] else {return }
                    let urlResult = UrlResult(full: full , thumb: thumb)
                    let photo = Photo(id: photoResult.id, size: CGSize(width: photoResult.width, height: photoResult.height), createdAt: photoResult.createdAt, welcomeDescription: photoResult.welcomeDescription, thumbImageURL: urlResult.thumb, largeImageURL: urlResult.full, isLiked: photoResult.isLiked)
                    newPhotos.append(photo)
                }
                photos.append(contentsOf: newPhotos)
                //TODO: Уведомление доделать
                NotificationCenter.default.post(name: ImageListService.didChangeNotification,object: self)
                lastLoadedPage = nextPage
            case .failure(let error):
                print(error)
            }
            self.task = nil
        }
        
        task.resume()
        
        
    }
    
    
}
