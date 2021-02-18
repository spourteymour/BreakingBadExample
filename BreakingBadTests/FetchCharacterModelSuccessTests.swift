//
//  BreakingBadTests.swift
//  BreakingBadTests
//
//  Created by Sepandat Pourtaymour on 15/02/2021.
//  Copyright © 2021 Sepandat Pourtaymour. All rights reserved.
//

import XCTest
@testable import BreakingBad

class FetchCharacterModelSuccessTests: XCTestCase {
	let mockNetworkManager = MockNetworkManager()
	lazy var fetchModel = CharacterFetchModel(networkManager: mockNetworkManager)

    override func setUp() {
		mockNetworkManager.setupWithExpectedOutCome(shouldFail: false, error: nil, successResponsePath: "mockCharacterFetchSuccessResponse")
    }

    func testCharacterModel_whenCallIsMadeAndResponseIsAvailable_shouldReturnCorrectContent() {
        let expectation = self.expectation(description: "Scaling")
		var fetchedCharacters: [Character]?
		
		fetchModel.fetchCharacters { (result) in
			fetchedCharacters = try? result.get()
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertNotNil(fetchedCharacters)
    }
	
    func testCharacterModel_whenCallIsMadeAndResponseIsAvailable_shouldHaveContent() {
        let expectation = self.expectation(description: "Scaling")
		fetchModel.fetchCharacters { (result) in
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		
		XCTAssert(fetchModel.fetchedContents.count > 0)
    }

    func testCharacterModel_whenCallIsMadeAndResponseIsAvailable_shouldHaveSeasons() {
        let expectation = self.expectation(description: "Scaling")
		fetchModel.fetchCharacters { (result) in
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		
		XCTAssert(fetchModel.fetchAllSeasons().count > 0)
    }
	
    func testCharacterModel_whenCallIsMadeAndResponseIsAvailable_shouldHaveSpecificSeasons() {
        let expectation = self.expectation(description: "Scaling")
		fetchModel.fetchCharacters { (result) in
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		
		let expectedSeasons = [1,2,3,4,5]
		XCTAssertEqual(expectedSeasons, fetchModel.fetchAllSeasons())
    }
}
