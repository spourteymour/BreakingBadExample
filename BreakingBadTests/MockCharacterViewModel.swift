//
//  MockCharacterViewModel.swift
//  BreakingBadTests
//
//  Created by Sepandat Pourtaymour on 18/02/2021.
//  Copyright © 2021 Sepandat Pourtaymour. All rights reserved.
//

import XCTest
@testable import BreakingBad

class MockNetworkManager: NetworkClient {
	var shouldFail: Bool = false
	var failureError: AppError?
	var successResponsePath: String?
	
	func setupWithExpectedOutCome(shouldFail: Bool, error: AppError?, successResponsePath: String?) {
		self.shouldFail = shouldFail
		self.failureError = error
		self.successResponsePath = successResponsePath
	}
	
	func makeNetworkCall<T>(endpoint: String, completion: @escaping ((Result<T, AppError>) -> Void)) where T : Decodable, T : Encodable {
		if shouldFail {
			if let error = failureError {
				completion(.failure(error))
			} else {
				fatalError("Need failure error")
			}
		} else {
			guard let path = Bundle(for: Self.self).path(forResource: successResponsePath, ofType: "json"),
				let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
				let decodedObjects = try? JSONDecoder().decode(T.self, from: data) else { fatalError("Incompatible json and generic type") }
			completion(.success(decodedObjects))
		}
	}
}
