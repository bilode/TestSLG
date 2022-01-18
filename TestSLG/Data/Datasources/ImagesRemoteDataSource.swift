//
//  ImagesRemoteDataSource.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 13/01/2022.
//

import Foundation
import Combine

protocol ImagesRemoteDataSourcePort {
    func getImage(withURL: String) -> AnyPublisher<Data, Error>
}

class ImagesRemoteDataSourceAdapter: ImagesRemoteDataSourcePort {
    
    enum RemoteDataSourceError: Error {
        case urlFormat
    }
    
    var apiClient: APIClient
    
    init(client: APIClient) {
        self.apiClient = client
    }
    
    func getImage(withURL stringURL: String) -> AnyPublisher<Data, Error> {
        
        guard let url = URL(string:stringURL) else {
            return Fail(error: RemoteDataSourceError.urlFormat).eraseToAnyPublisher()
        }
        
        return self.apiClient.downloadImage(url: url)
    }
}
