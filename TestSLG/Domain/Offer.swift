//
//  Offer.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import Foundation

struct Offer: OfferCellInput {
    
    let bedrooms: Int?
    let rooms: Int?
    let url: String?
    
    let city: String
    let id: Int
    let area: Double
    let price: Double
    let professional: String
    let propertyType: String
    
    init(from offer: APIOffer) {
        self.bedrooms = offer.bedrooms
        self.rooms = offer.rooms
        self.url = offer.url
        self.city = offer.city
        self.id = offer.id
        self.area = offer.area
        self.price = offer.price
        self.professional = offer.professional
        self.propertyType = offer.propertyType
    }
}
