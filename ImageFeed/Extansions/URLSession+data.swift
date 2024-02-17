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
