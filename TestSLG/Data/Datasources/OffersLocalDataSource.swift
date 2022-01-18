//
//  LocalDataSource.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 11/01/2022.
//

import Foundation
import Combine

enum LocalDataSourceError: Error {
    case notFound
}

protocol OffersLocalDataSourcePort {
    
    func fetchOffers() -> AnyPublisher<[Offer], LocalDataSourceError>
    func fetchOfferDetails(id: Int) -> AnyPublisher<OfferDetails, LocalDataSourceError>
    
    func saveOffers(_: [Offer]) -> AnyPublisher<Void, Never>
    func saveOfferDetails(_: OfferDetails) -> AnyPublisher<Void, Never>
}


class OffersLocalDataSourceAdapter: OffersLocalDataSourcePort {
    
    private var lastOffersList: [Offer] = []
    private var lastOfferDetails: [OfferDetails] = []
    
    
    func fetchOffers() -> AnyPublisher<[Offer], LocalDataSourceError> {
        guard !self.lastOffersList.isEmpty else {
            return Fail(error: LocalDataSourceError.notFound)
                .eraseToAnyPublisher()
        }
        
        return Just(lastOffersList)
            .setFailureType(to: LocalDataSourceError.self)
            .eraseToAnyPublisher()
    }
     
    func fetchOfferDetails(id: Int) -> AnyPublisher<OfferDetails, LocalDataSourceError> {
        
        let targetOffer = self.lastOfferDetails.first { $0.id == id }
        
        if let targetOffer = targetOffer {
            return Just(targetOffer)
                .setFailureType(to: LocalDataSourceError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: LocalDataSourceError.notFound)
                .eraseToAnyPublisher()
        }
    }
    
    func saveOffers(_ offers: [Offer]) -> AnyPublisher<Void, Never> {
        self.lastOffersList = offers
        
        return Just(())
            .eraseToAnyPublisher()
    }
    
    func saveOfferDetails(_ offerDetails: OfferDetails) -> AnyPublisher<Void, Never> {
        
        if let idx = self.lastOfferDetails.firstIndex(where: { storedOffer in
            offerDetails.id == storedOffer.id
        }) {
            self.lastOfferDetails[idx] = offerDetails
        } else {
            self.lastOfferDetails.append(offerDetails)
        }
        
        return Just(())
            .eraseToAnyPublisher()
    }
}
