//
//  OffersRepositorPort.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 11/01/2022.
//

import Foundation
import Combine

enum OffersRepositoryError : Error {
    case notHandled
}

protocol OffersRepositoryPort {
    
    func getOffers() -> AnyPublisher<[Offer], Error>
    func getOfferDetails(id: Int) -> AnyPublisher<OfferDetails, Error>
}
