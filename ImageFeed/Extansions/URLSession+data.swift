//
//  File.swift
//  ImageFeed
//
//  Created by Александр  Сухинин on 26.02.2024.
//

import Foundation

enum NetworkError: Error{
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession{
    func data(for request: URLRequest,handler: @escaping (Result<Data, Error>)-> Void) -> URLSessionTask {
        let completitionOnMainThread: (Result<Data,Error>) -> Void = { result in
            DispatchQueue.main.async{
                handler(result)
            }
        }
        let task =  dataTask(with: request){ data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    completitionOnMainThread(.success(data))
                }else {
                    completitionOnMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                completitionOnMainThread(.failure(NetworkError.urlRequestError(error)))
            }else {
                completitionOnMainThread(.failure(NetworkError.urlSessionError))
            }
        }
        return task
    }
}

extension URLSession{
    func objectTask<T:Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T,Error>) -> Void
    ) -> URLSessionTask{
        let decoder = JSONDecoder()
        let task = data(for: request){ (result: Result<Data,Error>) in
            switch result{
            case .success(let data):
                do {
                    let response = try decoder.decode(T.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}
