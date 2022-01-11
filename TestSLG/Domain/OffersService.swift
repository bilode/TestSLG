//
//  OffersService.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import Foundation
import Combine

class OffersService: OffersListProvider {//}, OfferDetailsProvider {
    
//    var localStorage: LocalStoragePort
    var remoteStorage: RemoteStoragePort
    
    @Published private(set) var offers: [Offer]
    
    private let listingURL = URL(string: "https://gsl-apps-technical-test.dignp.com/listings.json")!
    private func detailsURL(forID id: Int) -> URL {
        return URL(string: "https://gsl-apps-technical-test.dignp.com/listings/{\(id)}.json")!
    }
    
    // MARK: - Initializers
    
    init(remoteStorage: RemoteStoragePort) {
        
        self.remoteStorage = remoteStorage
        self.offers = []
    }
    
    func fetchOffers() -> AnyPublisher<[OfferCellInput], Error> {
        return (remoteStorage.fetch(URLRequest(url: self.listingURL), JSONDecoder()) as AnyPublisher<APIOffersListing, Error>)
            .map { listing in
                listing.items.map { Offer(from: $0) }
            }
            .eraseToAnyPublisher()
    }
    
//    func fetchOfferDetails(forID id: Int) -> AnyPublisher<[OfferDetailsInput], Error> {
//        return (remoteStorage.fetch(URLRequest(url: self.detailsURL(forID: id) ), JSONDecoder()) as AnyPublisher<APIOffersListing, Error>)
//            .map { listing in
//                listing.items.map { Offer(from: $0) }
//            }
//            .eraseToAnyPublisher()
//    }
    
}
