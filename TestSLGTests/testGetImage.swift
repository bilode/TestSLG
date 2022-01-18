//
//  testGetImage.swift
//  TestSLGTests
//
//  Created by Timothée Bilodeau on 18/01/2022.
//

import XCTest
import Combine
@testable import TestSLG

fileprivate class ImagesRepositoryMock: ImagesRepositoryPort {
    
    var output: AnyPublisher<Data, Error>
    
    init(output: AnyPublisher<Data, Error>) {
        self.output = output
    }
    
    func getImage(withURL: String) -> AnyPublisher<Data, Error> {
        return self.output
    }
}

class testGetImage: XCTestCase {

    func testCallWithData() throws {
        // Arrange
        let expectation = self.expectation(description: "call")
        var cancellable: AnyCancellable
        
        let inputData = Data()
        let output: AnyPublisher<Data, Error> = Just(inputData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let getImage = GetImage(imageRepository: ImagesRepositoryMock(output: output))
        
        // Act
        var errorOutput: Error?
        var outputData: Data?
        var finished: Bool = false
        
        cancellable = getImage.call(withURL: "")
            .sink(receiveCompletion: { completion in
                
                switch completion {
                case .finished:
                    finished = true
                case .failure(let error):
                    errorOutput = error
                }
                expectation.fulfill()
            }, receiveValue: { data in
                outputData = data
            })
        
        waitForExpectations(timeout: 1.0)
        cancellable.cancel()

        // Assert
        XCTAssertNil(errorOutput)
        XCTAssertEqual(outputData, inputData)
        XCTAssertTrue(finished)
    }
    
    func testError() throws {
        // Arrange
        let expectation = self.expectation(description: "call")
        var cancellable: AnyCancellable
        
        let output: AnyPublisher<Data, Error> = Fail(error: ImagesRepositoryError.notHandled).eraseToAnyPublisher()
        
        let getImage = GetImage(imageRepository: ImagesRepositoryMock(output: output))
        
        // Act
        var errorOutput: Error?
        var dataOutput: Data?
        var finished: Bool = false
        
        cancellable = getImage.call(withURL: "")
            .sink(receiveCompletion: { completion in
                
                switch completion {
                case .finished:
                    finished = true
                case .failure(let error):
                    errorOutput = error
                }
                expectation.fulfill()
            }, receiveValue: { data in
                dataOutput = data
            })
        
        waitForExpectations(timeout: 1.0)
        cancellable.cancel()

        // Assert
        XCTAssertNotNil(errorOutput as? ImagesRepositoryError)
        XCTAssertEqual(errorOutput as! ImagesRepositoryError, ImagesRepositoryError.notHandled)
        XCTAssertNil(dataOutput)
        XCTAssertFalse(finished)
    }
}
