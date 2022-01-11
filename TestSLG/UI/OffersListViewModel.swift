//
//  OffersListViewModel.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import Foundation
import Combine

protocol OffersListProvider {
    func fetchOffers() -> AnyPublisher<[OfferCellInput], Error>
}

class OffersListViewModel {
    
    let offersProvider: OffersListProvider
    
    var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Publishers
    var dataSourceDidChange = PassthroughSubject<Void, Never>()
    
    // MARK: - Initializers
    init(with offersProvider: OffersListProvider) {
        
        self.offersProvider = offersProvider
    }
    
    // MARK: - View events
    
    func viewDidLoad() {
        self.offersProvider.fetchOffers().sink { completion in
            switch completion {
            case .finished:
                print("Finished fetching offers")
            case .failure(let error):
                print("Error fetching offers: \(error)")
            }
        } receiveValue: { offers in
            print("offers: \(offers)")
            self.dataSourceDidChange.send()
        }.store(in: &self.subscriptions)

    }
}
