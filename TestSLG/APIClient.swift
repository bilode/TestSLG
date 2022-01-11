//
//  APIClient.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import Combine
import Foundation

struct APIClient: RemoteStoragePort {
    
    enum ClientError: Error {
        case unknown
        case statusCode(Int)
        case invalidURL
        case underlying(Error)
    }
    
    var session: URLSession = {
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringCacheData
        let session = URLSession(configuration: config)
        return session
    }()
    
    func save() {
        
    }
    
    func fetch<T: Decodable>(
        _ request: URLRequest,
        _ decoder: JSONDecoder
    ) -> AnyPublisher<T, Error> {
        self.session
            .dataTaskPublisher(for: request)
            .tryMap { response in
                
                let httpURLResponse = response.response as? HTTPURLResponse
                
                guard httpURLResponse?.statusCode == 200 else {
                    throw httpURLResponse != nil ?
                    ClientError.statusCode(httpURLResponse!.statusCode) :
                    ClientError.unknown
                }
                
                return response.data
            }
            .decode(type: T.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    static func downloadImage(url: String) -> AnyPublisher<Data, Error> {
        
        guard let url = URL(string: url) else {
            return Fail(error: ClientError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { response -> Data in
                
                let httpURLResponse = response.response as? HTTPURLResponse
                
                guard httpURLResponse?.statusCode == 200 else {
                    throw httpURLResponse != nil ?
                    ClientError.statusCode(httpURLResponse!.statusCode) :
                    ClientError.unknown
                }
                
                return response.data
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
