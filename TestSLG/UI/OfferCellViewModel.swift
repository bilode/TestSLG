//
//  OfferCellViewModel.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 13/01/2022.
//

import Foundation
import Combine

class OfferCellViewModel {
    
    let imageGetter: GetImage
    
    var imageURL: String?
    
    let id: Int
    
    let roomsText: String?
    let areaText: String
    let priceText: String
    
    @Published var imageData: Data?
    
    var subscriptions: Set<AnyCancellable> = []
    
    init(from offer: Offer, imageGetter: GetImage) {
        self.id = offer.id
        self.imageURL = offer.url
        self.roomsText = offer.rooms != nil ? String(format: "%u pièces", offer.rooms!) : nil
        self.areaText = String(format: "%.0f m²", offer.area)
        self.priceText = String(format: "%.0f €", offer.price)
        
        self.imageGetter = imageGetter
    }
    
    // MARK: - View events
    
    func viewDidDisappear() {
        self.cancelDownload()
    }
    
    func viewDidFinishSetingUp() {
        if let url = self.imageURL {
            self.downloadImage(url: url)
        }
    }
    
    // MARK: - Private
    
    private func cancelDownload() {
        self.subscriptions.forEach { $0.cancel() }
    }
    
    private func downloadImage(url: String) {
        self.imageGetter.call(withURL: url).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print("error getting image: \(error)")
            }
        } receiveValue: { [weak self] data in
            self?.imageData = data
        }
        .store(in: &self.subscriptions)
    }
}
