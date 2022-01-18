//
//  ImagesRepositoryPort.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 18/01/2022.
//

import Foundation
import Combine


enum ImagesRepositoryError : Error {
    case notHandled
}

protocol ImagesRepositoryPort {
    
    func getImage(withURL: String) -> AnyPublisher<Data, Error>
}
