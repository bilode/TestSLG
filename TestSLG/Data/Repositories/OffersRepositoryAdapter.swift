//
//  OffersRepositoryAdapter.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 11/01/2022.
//

import Foundation
import Combine

class OffersRepositoryAdapter: OffersRepositoryPort {
    
    var remoteDataSource: OffersRemoteDataSourcePort
    var localDataSource: OffersLocalDataSourcePort
    
    var subscriptions: Set<AnyCancellable> = []
    
    init(remoteDataSource: OffersRemoteDataSourcePort, localDataSource: OffersLocalDataSourcePort) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getOffers() -> AnyPublisher<[Offer], Error> {
        
        if !self.shouldUseCachedData() {
            
            return self.remoteDataSource.fetchOffers()
                .tryMap { [weak self] offers in
                    
                    guard let self = self else { throw OffersRepositoryError.notHandled }
                    
                    // This is wrong, for appropriate chaining we would probably
                    // need to create our own custom publisher with <Offers, Error>
                    // as both input and output
                    self.localDataSource.saveOffers(offers).sink { _ in }
                    .store(in: &self.subscriptions)
                    
                    return offers
                }
                .eraseToAnyPublisher()
            
        } else {
            
            return self.localDataSource.fetchOffers()
                .mapError { dataSourceError in
                    return dataSourceError as Error
                }
                .eraseToAnyPublisher()
        }
    }
    
    func getOfferDetails(id: Int) -> AnyPublisher<OfferDetails, Error> {
        if !self.shouldUseCachedData() {
            return self.remoteDataSource.fetchOfferDetails(id: id)
                .tryMap { [weak self] details in
                    
                    guard let self = self else { throw OffersRepositoryError.notHandled }
                    
                    self.localDataSource.saveOfferDetails(details).sink { _ in }
                    .store(in: &self.subscriptions)
                    
                    return details
                }
                .eraseToAnyPublisher()
        } else {
            
            return self.localDataSource.fetchOfferDetails(id: id)
                .mapError { dataSourceError in
                    return dataSourceError as Error
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func shouldUseCachedData() -> Bool {
        // Todo: we should maybe add a dependency that would check if the last remote fetch date is
        // within a certain interval, or we may also check if we're connected to internet, or we could do both
        return false
    }
}
