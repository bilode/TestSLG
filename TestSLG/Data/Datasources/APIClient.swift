//
//  APIClient.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import Combine
import Foundation

class APIClient {
    
    enum ClientError: Error {
        case unknown
        case statusCode(Int)
        case invalidURL
        case underlying(Error)
    }
    
    // Session configuration for testing purpose along with the iOS network link conditioner
    var session: URLSession = {
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringCacheData
        let session = URLSession(configuration: config)
        return session
    }()
    
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
    
    
    func downloadImage(url: URL) -> AnyPublisher<Data, Error> {
        
        return self.session.dataTaskPublisher(for: url)
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
