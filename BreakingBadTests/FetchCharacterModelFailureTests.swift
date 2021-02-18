//
//  BreakingBadTests.swift
//  BreakingBadTests
//
//  Created by Sepandat Pourtaymour on 15/02/2021.
//  Copyright © 2021 Sepandat Pourtaymour. All rights reserved.
//

import XCTest
@testable import BreakingBad

class FetchCharacterModelFailureTests: XCTestCase {
	
	let mockNetworkManager = MockNetworkManager()
	lazy var fetchModel = CharacterFetchModel(networkManager: mockNetworkManager)

    func testNetworkSuccess_whenCallIsMadeAndResponseIsUnavailable_shouldReturnError() {
        let expectation = self.expectation(description: "Scaling")

		let expectedError = AppError.networkError("Dummy NetworkError")
		mockNetworkManager.setupWithExpectedOutCome(shouldFail: true, error: expectedError, successResponsePath: nil)

		var receivedError: AppError?
		
		fetchModel.fetchCharacters { (result) in
			switch result {
			case .failure(let error): receivedError = error
			default: break
			}
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(receivedError)
		if case AppError.networkError("Dummy NetworkError") = receivedError! {
			
		}
		XCTAssert(expectedError == receivedError!)

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
