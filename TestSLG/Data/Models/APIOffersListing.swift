//
//  APIOffersListing.swift
//  TestSLG
//
//  Created by Timothée Bilodeau on 11/01/2022.
//


struct APIOffersListing: Decodable {
    let items: [Offer]
    let totalCount: Int
}
