//
//  ImagesRepositoryAdapter.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 18/01/2022.
//

import Foundation
import Combine

class ImagesRepositoryAdapter: ImagesRepositoryPort {
    
    var remoteDataSource: ImagesRemoteDataSourcePort
    
    var subscriptions: Set<AnyCancellable> = []
    
    init(withRemoteDataSource remoteDataSource: ImagesRemoteDataSourcePort) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getImage(withURL url: String) -> AnyPublisher<Data, Error> {
        remoteDataSource.getImage(withURL: url)
    }
}
