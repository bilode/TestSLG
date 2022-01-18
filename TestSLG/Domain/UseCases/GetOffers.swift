//
//  GetOffers.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 11/01/2022.
//

import Foundation
import Combine

class GetOffers {
    
    var offersRepository: OffersRepositoryPort
    
    init(offersRepository: OffersRepositoryPort) {
        self.offersRepository = offersRepository
    }
    
    func call() -> AnyPublisher<[Offer], Error> {
        return offersRepository.getOffers()
    }
}
