//
//  Offer+Decodable.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 11/01/2022.
//

import Foundation

extension Offer: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case bedrooms
        case rooms
        case url
        case city
        case id
        case area
        case price
        case professional
        case propertyType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.bedrooms = try? container.decode(Int.self, forKey: .bedrooms)
        self.rooms = try? container.decode(Int.self, forKey: .rooms)
        self.url = try? container.decode(String.self, forKey: .url)
        
        self.city = try container.decode(String.self, forKey: .city)
        self.id = try container.decode(Int.self, forKey: .id)
        self.area = try container.decode(Double.self, forKey: .area)
        self.price = try container.decode(Double.self, forKey: .price)
        self.professional = try container.decode(String.self, forKey: .professional)
        self.propertyType = try container.decode(String.self, forKey: .propertyType)
    }
}
