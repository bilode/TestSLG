//
//  Offer.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import Foundation

struct Offer: Equatable {
    
    let id: Int
    
    let rooms: Int?
    let bedrooms: Int?
    let url: String?
    
    let city: String
    let area: Double
    let price: Double
    let professional: String
    let propertyType: String
}
