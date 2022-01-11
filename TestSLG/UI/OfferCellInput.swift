//
//  OfferInput.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 06/01/2022.
//

import Foundation

protocol OfferCellInput {
    
    var bedrooms: Int? { get }
    var rooms: Int? { get }
    var url: String? { get }
    
    var city: String { get }
    var id: Int { get }
    var area: Double { get }
    var price: Double { get }
    var professional: String { get }
    var propertyType: String { get }
}
