//
//  OfferDetailsViewModel.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import Foundation
import Combine

protocol OfferDetailsProvider {
    func getOfferDetails() -> AnyPublisher<OfferDetailsInput, Error>
}

struct OfferDetailsViewModel {
    
}
