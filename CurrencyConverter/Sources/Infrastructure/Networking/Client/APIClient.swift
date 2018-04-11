//
//  NetworkingClient.swift
//  CurrencyConverter
//
//  Created by Dmitry Tuhtamanov on 11/04/2018.
//  Copyright © 2018 tuhtamanov. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

enum APIError: Error {
    case requestURLConstructionFailed
    case invalidResponse
}

final class APIClient {
    private let baseURL: String
    private let accessKey: String
    private let manager: SessionManager
    private let responseProcessingQueue: DispatchQueue

    init(baseURL: String, accessKey: String) {
        self.baseURL = baseURL
        self.accessKey = accessKey

        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.urlCache = nil
        self.manager = Alamofire.SessionManager(configuration: config)

        self.responseProcessingQueue = DispatchQueue(label: "com.networking.response_processing_queue")
    }

    func execute<Serializer: Serialization>(request: APIRequest, serializer: Serializer) -> Single<Serializer.Entity> {
        guard let url = constructURL(for: request) else {
            return .error(APIError.requestURLConstructionFailed)
        }

        return .create { (observer) in
            self.manager.request(url).responseJSON(queue: self.responseProcessingQueue) { (response) in
                switch response.result {
                case let .success(data):
                    if let json = data as? RawJSON, let entity = serializer.serialize(json: json) {
                        observer(.success(entity))
                    } else {
                        observer(.error(APIError.invalidResponse))
                    }
                case let .failure(error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }

    private func constructURL(for request: APIRequest) -> URL? {
        var components = URLComponents(string: baseURL)
        components?.path = request.path
        components?.queryItems = [URLQueryItem(name: "access_key", value: accessKey)]
        return components?.url
    }
}
