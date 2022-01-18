//
//  OffersRemoteDataSource.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 11/01/2022.
//

import Foundation
import Combine

protocol OffersRemoteDataSourcePort {
    
    func fetchOffers() -> AnyPublisher<[Offer], Error>
    func fetchOfferDetails(id: Int) -> AnyPublisher<OfferDetails, Error>
}

class OffersRemoteDataSourceAdapter: OffersRemoteDataSourcePort {
    
    enum RemoteDataSourceError: Error {
        case urlFormat
    }
    
    var apiClient: APIClient
    
    private let listingURL = URL(string: "https://gsl-apps-technical-test.dignp.com/listings.json")
    
    private func detailsURL(forID id: Int) -> URL? {
        return URL(string: "https://gsl-apps-technical-test.dignp.com/listings/\(id).json")
    }
    
    init(client: APIClient) {
        self.apiClient = client
    }
    
    
    func fetchOffers() -> AnyPublisher<[Offer], Error> {
        
        guard let url = self.listingURL else {
            return Fail(error: RemoteDataSourceError.urlFormat).eraseToAnyPublisher()
        }
        
        return (apiClient.fetch(URLRequest(url: url), JSONDecoder()) as AnyPublisher<APIOffersListing, Error>)
            .map { $0.items }
            .eraseToAnyPublisher()
    }
    
    
    func fetchOfferDetails(id: Int) -> AnyPublisher<OfferDetails, Error> {
        
        guard let url = self.detailsURL(forID: id) else {
            return Fail(error: RemoteDataSourceError.urlFormat).eraseToAnyPublisher()
        }
        
        return apiClient.fetch(URLRequest(url: url), JSONDecoder())
    }
    
}
