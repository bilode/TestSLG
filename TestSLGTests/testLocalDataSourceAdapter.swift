//
//  testLocalDataSourceAdapter.swift
//  TestSLGTests
//
//  Created by Timothée Bilodeau on 18/01/2022.
//

import XCTest
import Combine
@testable import TestSLG

class testLocalDataSourceAdapter: XCTestCase {

    private let tOffersInput: [Offer] = [
        Offer(id: 0, rooms: nil, bedrooms: 1, url: nil, city: "Toronto", area: 250.0, price: 99.0, professional: "Dummy professional", propertyType: "House"),
        Offer(id: 1, rooms: nil, bedrooms: 2, url: nil, city: "New York", area: 300.0, price: 999.0, professional: "Dummy professional", propertyType: "Flat"),
        Offer(id: 2, rooms: nil, bedrooms: 1, url: nil, city: "Paris", area: 250.0, price: 99.0, professional: "Dummy professional", propertyType: "House"),
        Offer(id: 3, rooms: nil, bedrooms: 2, url: nil, city: "Venice", area: 300.0, price: 999.0, professional: "Dummy professional", propertyType: "Flat")
    ]
    
    func testAddOffersList() {
        
        // Arrange
        let localDataSource = OffersLocalDataSourceAdapter()
        
        // Act
        let saveExpectation = self.expectation(description: "save")
        var cancellable: AnyCancellable
        
        cancellable = localDataSource.saveOffers(self.tOffersInput)
            .sink(receiveValue: { _ in
                saveExpectation.fulfill()
            })

        waitForExpectations(timeout: 1.0)
        cancellable.cancel()
        
        let fetchExpectation = self.expectation(description: "fetch")
        
        var errorOutput: Error?
        var offersOutput: [Offer] = []
        var finished: Bool = false
        
        cancellable = localDataSource.fetchOffers()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    finished = true
                case .failure(let error):
                    errorOutput = error
                }
                fetchExpectation.fulfill()
            }, receiveValue: { offers in
                offersOutput = offers
            })
        
        waitForExpectations(timeout: 1.0)
        cancellable.cancel()
        
        // Assert
        XCTAssertEqual(offersOutput.count, 4)
        XCTAssertTrue(finished)
        XCTAssertNil(errorOutput)
    }
    
    func testFetchOffersListNotFound() {
        // Arrange
        let localDataSource = OffersLocalDataSourceAdapter()
        
        // Act
        let fetchExpectation = self.expectation(description: "fetch")
        var cancellable: AnyCancellable
        
        var errorOutput: Error?
        var offersOutput: [Offer] = []
        var finished: Bool = false
        
        cancellable = localDataSource.fetchOffers()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    finished = true
                case .failure(let error):
                    errorOutput = error
                }
                fetchExpectation.fulfill()
            }, receiveValue: { offers in
                offersOutput = offers
            })
        
        waitForExpectations(timeout: 1.0)
        cancellable.cancel()
        
        // Assert
        XCTAssertEqual(offersOutput.count, 0)
        XCTAssertFalse(finished)
        XCTAssertNotNil(errorOutput as? LocalDataSourceError)
        XCTAssertEqual(errorOutput as! LocalDataSourceError, LocalDataSourceError.notFound)
    }

    // And so on...
}
