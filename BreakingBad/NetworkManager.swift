//
//  NetworkManager.swift
//  BiPPartner
//
//  Created by Sepandat Pourtaymour on 22/12/2020.
//  Copyright © 2020 Sepandat Pourtaymour. All rights reserved.
//

import UIKit

enum AppError: Error, Equatable {
	 case invalidURL
	case nativeError(Error)
	case networkError(String)
	
    static func ==(lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
		case (.invalidURL, .invalidURL): return true
		case (let .nativeError(error1), let .nativeError(error2)): return error1.localizedDescription == error2.localizedDescription
		case (let .networkError(error1), let .networkError(error2)): return error1.lowercased() == error2.lowercased()
        default: return false
        }
    }
}

typealias FetchResponse<T> = ((Result<T, AppError>) -> Void)

protocol NetworkClient {
	func makeNetworkCall<T: Codable>(endpoint: String, completion: @escaping FetchResponse<T>)
}

class NetworkManager: NSObject, NetworkClient {
	func makeNetworkCall<T: Codable>(endpoint: String, completion: @escaping FetchResponse<T>) {
		guard let url = URL(string: endpoint) else {
			completion(.failure(.invalidURL))
			return
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			if let error = error {
				completion(.failure(.nativeError(error)))
				return
			}
			guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
				var reason = "unknown with code: \((response as? HTTPURLResponse)?.statusCode ?? -111)"
				if let data = data, let string = String(data: data, encoding: .utf8) {
					reason = string
				}
				completion(.failure(.networkError(reason)))
				return
			}
			do {
				guard let data = data else {
					completion(.failure(.networkError("Could not convert to type: \(String(describing: T.self))")))
					return
				}
				let toRet = try JSONDecoder().decode(T.self, from: data)
				completion(.success(toRet))
			} catch {
				completion(.failure(.nativeError(error)))
			}
		}.resume()
	}
}
