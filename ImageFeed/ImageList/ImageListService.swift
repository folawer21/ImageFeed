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
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Codable{
    var id: String
    var width: Int
    var height: Int
    var createdAt: String?
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
        let task = URLSession.shared.data(for: request){[weak self] (result: Result<Data,Error>) in
            let decoder = JSONDecoder()
            var newPhotos: [Photo] = []
            guard let self = self else {return }
            switch result{
            case .success(let data):
                do {
                    let photoResults = try decoder.decode([PhotoResult].self, from: data)
                    print("AAAAAAAAAAA")
                    for photoResult in photoResults{
                        let urls = photoResult.urls
                        guard let full = urls["full"], let thumb = urls["thumb"] else {return }
                        let urlResult = UrlResult(full: full , thumb: thumb)
                        let photo = Photo(id: photoResult.id, size: CGSize(width: photoResult.width, height: photoResult.height), createdAt: photoResult.createdAt, welcomeDescription: photoResult.welcomeDescription, thumbImageURL: urlResult.thumb, largeImageURL: urlResult.full, isLiked: photoResult.isLiked)
                        newPhotos.append(photo)
                    }
                    self.photos.append(contentsOf: newPhotos)
                    NotificationCenter.default.post(name: ImageListService.didChangeNotification,object: self)
                    self.lastLoadedPage = nextPage
                } catch{
                    print("BBBBBBBBBB")
                    print(error)
                }
            case .failure(let error):
                print("CCCCCCCCCCCCCCCCC")
                print(error)
            }
            self.task = nil
        }
        task.resume()
    }
    func likeButtonService(id: String, isLike: Bool,_ completion: @escaping (Result<Void,Error>) -> Void ){
        let urlString = "https://api.unsplash.com/photos/\(id)/like"
        guard let url = URL(string: urlString) else {
            print("Error with URL")
            return }
        var request = URLRequest(url: url)
        if isLike{
            request.httpMethod = "DELETE"
        }
        else{
            request.httpMethod = "POST"
        }
        
        let task = URLSession.shared.data(for: request) { [weak self] (result: Result<Data,Error>) in
            guard let self = self else {return }
            switch result{
            case .success(let data):
                let decoder = JSONDecoder()
                do{
                    //TODO: custom Photo init(from: PhotoResult)
                    let photoResult = try decoder.decode(PhotoResult.self, from: data)
                    let urls = photoResult.urls
                    guard let full = urls["full"], let thumb = urls["thumb"] else {return }
                    let urlResult = UrlResult(full: full , thumb: thumb)
                    let photo = Photo(id: photoResult.id, size: CGSize(width: photoResult.width, height: photoResult.height), createdAt: photoResult.createdAt, welcomeDescription: photoResult.welcomeDescription, thumbImageURL: urlResult.thumb, largeImageURL: urlResult.full, isLiked: photoResult.isLiked)
                    guard let index = self.photos.firstIndex(where: { $0.id == photo.id}) else {
                        print("Error with getting index while likeTapping )")
                        return
                    }
                    DispatchQueue.main.async{
                        self.photos[index] = photo
                    }
                    completion(.success(Void()))
                }catch {
                    print("Error while decoding likeResponse : \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Error with likeButton request: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

