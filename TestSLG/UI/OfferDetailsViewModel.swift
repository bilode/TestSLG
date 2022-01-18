//
//  OfferDetailsViewModel.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import Foundation
import Combine


class OfferDetailsViewModel {
    
    private let targetOfferId: Int
    
    // MARK: - Use cases
    let offerDetailsGetter: GetOfferDetails
    let imageGetter: GetImage
    
    // MARK: - Entities
    @Published private(set) var dataSource: OfferDetails?
    
    // MARK: - Publishers
    @Published private(set) var isLoading: Bool
    @Published private(set) var imageData: Data?
    
    // We could also make them into publishers and zip everything
    // But we will go for the more sober, less messy approach
    var roomsText: String?
    var bedroomsText: String?
    var cityText: String
    var areaText: String
    var priceText: String
    var professionalText: String
    var propertyTypeText: String
    
    var dataSourceDidChange = PassthroughSubject<Void, Never>()
    
    var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    init(with offerId: Int, offerDetailsGetter: GetOfferDetails,
         imageGetter: GetImage) {
        
        self.targetOfferId = offerId
        
        self.offerDetailsGetter = offerDetailsGetter
        self.imageGetter = imageGetter
        self.isLoading = false
        
        self.roomsText = nil
        self.bedroomsText = nil
        self.cityText = ""
        self.areaText = ""
        self.priceText = ""
        self.professionalText = ""
        self.propertyTypeText = ""
        
        self.setupBinding()
    }
    
    // MARK: - Network
    
    private func fetchOfferDetails() {
        
        self.isLoading = true
        self.offerDetailsGetter.call(id: self.targetOfferId)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("error fetching offerDetails: \(error)")
                }
                self.isLoading = false
            } receiveValue: { offer in
                self.dataSource = offer
            }
            .store(in: &self.subscriptions)
    }
    
    // MARK: - Binding
    
    private func setupBinding() {
        
        self.$dataSource.sink { offerDetails in
            guard let offerDetails = offerDetails else {
                return
            }
            
            self.updateViewContent(from: offerDetails)
            if let imageURL = offerDetails.url {
                self.downloadImage(url: imageURL)
            }
            
            self.dataSourceDidChange.send()
        }
        .store(in: &self.subscriptions)
    }
    
    // MARK: - View events
    
    func viewDidAppear() {
        
        self.fetchOfferDetails()
    }
    
    // MARK: - View content
    
    private func updateViewContent(from offerDetails: OfferDetails) {
        
        self.roomsText = offerDetails.rooms != nil ? String(format: "%u pièce(s)", offerDetails.rooms!) : nil
        self.bedroomsText = offerDetails.bedrooms != nil ? String(format: "%u chambre(s)", offerDetails.bedrooms!) : nil
        self.cityText = offerDetails.city
        self.areaText = String(format: "%.0f m²", offerDetails.area)
        self.priceText = String(format: "%.0f €", offerDetails.price)
        self.professionalText = offerDetails.professional
        self.propertyTypeText = offerDetails.propertyType
    }
    
    private func downloadImage(url: String) {
        self.imageGetter.call(withURL: url).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("Error getting image: \(error)")
            }
        } receiveValue: { [weak self] data in
            self?.imageData = data
        }
        .store(in: &self.subscriptions)
    }
}
