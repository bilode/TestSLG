//
//  RemoteStoragePort.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import Foundation
import Combine

protocol RemoteStoragePort {
    func save()
    func fetch<T: Decodable>(
        _ request: URLRequest,
        _ decoder: JSONDecoder
    ) -> AnyPublisher<T, Error>
}
