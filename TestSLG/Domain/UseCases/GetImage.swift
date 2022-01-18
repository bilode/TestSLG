//
//  GetImage.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 12/01/2022.
//

import Foundation

import Combine

class GetImage {
    
    var imageRepository: ImagesRepositoryPort
    
    init(imageRepository: ImagesRepositoryPort) {
        self.imageRepository = imageRepository
    }
    
    func call(withURL url: String) -> AnyPublisher<Data, Error> {
        return imageRepository.getImage(withURL: url)
    }
}
