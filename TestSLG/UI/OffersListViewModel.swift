//
//  OffersListViewModel.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import Foundation
import Combine


class OffersListViewModel {
    
    // MARK: - Use cases
    let offersGetter: GetOffers
    let imageGetter: GetImage
    
    // MARK: - Entities
    private var dataSource: [Offer] {
        didSet {
            self.dataSourceDidChange.send()
        }
    }
    
    // MARK: - Publishers
    @Published private(set) var isLoading: Bool
    @Published private(set) var offerToDetail: (Offer)?
    
    var dataSourceDidChange = PassthroughSubject<Void, Never>()
    
    var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    init(with offersGetter: GetOffers,
         imageGetter: GetImage) {
        
        self.offersGetter = offersGetter
        self.imageGetter = imageGetter
        self.isLoading = false
        
        self.dataSource = []
    }

    
    // MARK: - Network
    
    private func fetchOffers() {
        
        self.isLoading = true
        self.offersGetter.call()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("error fetching offers: \(error)")
                }
                self.isLoading = false
            } receiveValue: { offers in
                self.dataSource = offers
            }
            .store(in: &self.subscriptions)
    }
    
    // MARK: - Data
    
    private func refreshData() {
        self.fetchOffers()
    }
    
    // MARK: - View events
    
    func didSelectItem(atIndex index: Int) {
        guard index < self.dataSource.count else {
            return
        }
        
        self.offerToDetail = self.dataSource[index]
    }
    
    func refreshControlDidTrigger() {
        self.refreshData()
    }
    
    func viewDidAppear() {
        self.fetchOffers()
    }
    
    // MARK: - Data source

    func viewModelForCell(atIndex index: Int) -> OfferCellViewModel? {
        
        guard index < self.dataSource.count else {
            return nil
        }
        
        let offer = self.dataSource[index]
        
        return OfferCellViewModel(from: offer, imageGetter: self.imageGetter)
    }
    
    var numberOfItems: Int {
        return self.dataSource.count
    }
}

