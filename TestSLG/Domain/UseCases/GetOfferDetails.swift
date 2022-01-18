//
//  GetOfferDetails.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 11/01/2022.
//

import Foundation
import Combine

class GetOfferDetails {
    
    var offersRepository: OffersRepositoryPort
    
    init(offersRepository: OffersRepositoryPort) {
        self.offersRepository = offersRepository
    }
    
    func call(id: Int) -> AnyPublisher<OfferDetails, Error> {
        return offersRepository.getOfferDetails(id: id)
    }
}
