//
//  testOffersListViewModel.swift
//  TestSLGTests
//
//  Created by Timothée Bilodeau on 18/01/2022.
//

import XCTest
import Combine
@testable import TestSLG

fileprivate class OffersRepositoryMock: OffersRepositoryPort {
    
    var output: AnyPublisher<[Offer], Error>
    
    init(output: AnyPublisher<[Offer], Error>) {
        self.output = output
    }
    
    func getOffers() -> AnyPublisher<[Offer], Error> {
        return self.output
    }
    
    func getOfferDetails(id: Int) -> AnyPublisher<OfferDetails, Error> {
        return Fail(error: OffersRepositoryError.notHandled).eraseToAnyPublisher()
    }
}

fileprivate class ImagesRepositoryMock: ImagesRepositoryPort {
    func getImage(withURL: String) -> AnyPublisher<Data, Error> {
        return Fail(error: ImagesRepositoryError.notHandled).eraseToAnyPublisher()
    }
}


class testOffersListViewModel: XCTestCase {
    
    let tOffersInput: [Offer] = [
        Offer(id: 1, rooms: nil, bedrooms: 1, url: nil, city: "Toronto", area: 250.0, price: 99.0, professional: "Dummy professional", propertyType: "House"),
        Offer(id: 2, rooms: nil, bedrooms: 2, url: nil, city: "New York", area: 300.0, price: 999.0, professional: "Dummy professional", propertyType: "Flat")
    ]
    
    private func defaultFetch(viewModel: OffersListViewModel) {
        let expectation = self.expectation(description: "fetch")
        var cancellable: AnyCancellable

        cancellable = viewModel.dataSourceDidChange
            .sink { _ in
                expectation.fulfill()
            }
                
        viewModel.viewDidAppear()
        
        waitForExpectations(timeout: 1.0)
        cancellable.cancel()
    }

    func testFetch() throws {
        // Arrange
        let output = Just(self.tOffersInput)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let getOffers = GetOffers(offersRepository: OffersRepositoryMock(output: output))
        let getImage = GetImage(imageRepository: ImagesRepositoryMock())
        
        let viewModel = OffersListViewModel(with: getOffers, imageGetter: getImage)
        
        // Act
        self.defaultFetch(viewModel: viewModel)
        
        // Assert
        XCTAssertEqual(viewModel.numberOfItems, 2)
        XCTAssertNotNil(viewModel.viewModelForCell(atIndex:1))
        XCTAssertNil(viewModel.viewModelForCell(atIndex:2))
    }
    
    func testSelection() throws {
        // Arrange
        let output = Just(self.tOffersInput)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let getOffers = GetOffers(offersRepository: OffersRepositoryMock(output: output))
        let getImage = GetImage(imageRepository: ImagesRepositoryMock())
        
        let viewModel = OffersListViewModel(with: getOffers, imageGetter: getImage)
        
        // Act
        self.defaultFetch(viewModel: viewModel)
        viewModel.didSelectItem(atIndex: 0)
        
        // Assert
        XCTAssertNotEqual(self.tOffersInput.count, 0)
        XCTAssertEqual(viewModel.offerToDetail, self.tOffersInput[0])
    }
    
    func testLoading() throws {
        // Arrange
        let output = Just(self.tOffersInput)
            .setFailureType(to: Error.self)
            .delay(for: 0.01, scheduler: RunLoop.main)
            .eraseToAnyPublisher()
        
        let getOffers = GetOffers(offersRepository: OffersRepositoryMock(output: output))
        let getImage = GetImage(imageRepository: ImagesRepositoryMock())
        
        let viewModel = OffersListViewModel(with: getOffers, imageGetter: getImage)
        
        // Act
        let expectation = self.expectation(description: "fetch")
        var cancellable: AnyCancellable

        cancellable = viewModel.dataSourceDidChange
            .sink { _ in
                expectation.fulfill()
            }
                
        viewModel.viewDidAppear()
        
        // Assert
        XCTAssertTrue(viewModel.isLoading)
        
        // Act 2
        
        waitForExpectations(timeout: 1.0)
        cancellable.cancel()
        
        // Assert
        XCTAssertFalse(viewModel.isLoading)
    }

}
