//
//  CharacterFetchModel.swift
//  BreakingBad
//
//  Created by Sepandat Pourtaymour on 15/02/2021.
//  Copyright © 2021 Sepandat Pourtaymour. All rights reserved.
//

import Foundation

protocol  CharacterFetchable {
	var fetchedContents: [Character] { get set }
	var filteredContents: [Character] { get set }
	var lastError: AppError? { get set }
	func filterContentForSearchText(_ searchText: String?, completion: (Bool) -> Void)
	func fetchCharacters(fetchCompletion: @escaping FetchResponse<[Character]>)
	func fetchAllSeasons() -> [Int]
	func updateWithSeason(season: Int?, completion: (Int?) -> Void)
	func character(indexPath: IndexPath, isSearching: Bool) -> Character
}

class CharacterFetchModel: NSObject, CharacterFetchable {
	var fetchedContents = [Character]()
	var filteredContents = [Character]()
	
	private var _fetchedContents = [Character]()
	private var _filteredContents = [Character]()
	var currentSeason: Int?
	var lastError: AppError?
	
	var networkManager: NetworkClient
	
	init(networkManager: NetworkClient = NetworkManager()) {
		self.networkManager = networkManager
	}
	
	func fetchCharacters(fetchCompletion: @escaping FetchResponse<[Character]>) {
		networkManager.makeNetworkCall(endpoint: "https://breakingbadapi.com/api/characters", completion: { (result: Result<[Character], AppError>) in
			switch result {
			case .success(let characters):
				self.fetchedContents = characters
				self._fetchedContents = characters
				
				fetchCompletion(.success(characters))
			case .failure(let error):
				self.lastError = error
				fetchCompletion(.failure(error))
			}
		})
	}
	
	func filterContentForSearchText(_ searchText: String?, completion: (Bool) -> Void) {
		guard let searchedText = searchText, !searchedText.isEmpty else {
			completion(false)
			return
		}
		let filteredComponents = fetchedContents.filter {
			let contentName = $0.name.lowercased()
			let lowerCased = searchedText.lowercased()
			let isEqual = contentName == lowerCased
			let hasSome = contentName.contains(lowerCased)
			return isEqual || hasSome
		}
		
		filteredContents = filteredComponents
		_filteredContents = filteredComponents
		
		completion(true)
	}

	func updateWithSeason(season: Int? = nil, completion: (Int?) -> Void) {
		guard let season = season else {
			fetchedContents = _fetchedContents
			completion(nil)
			return
		}
		
		fetchedContents = _fetchedContents.reduce([], { (result: [Character], character) -> [Character] in
			var toRet = result
			if character.appearance.contains(season){
				toRet.append(character)
			}
			return toRet
		})
		
		completion(season)
	}
	
	func character(indexPath: IndexPath, isSearching: Bool) -> Character {
		let toSelectFrom = isSearching ? filteredContents : fetchedContents
		return toSelectFrom[indexPath.row]
	}
	
	func fetchAllSeasons() -> [Int] {
		let toRet = fetchedContents.reduce([]) { (result, character) -> [Int] in
			let appearances = character.appearance
			var toRet = result
			appearances.forEach({ appearance  in
				if !toRet.contains(appearance) {
					toRet.append(appearance)
				}

			})
			return toRet
		}
		return toRet.sorted(by: {$0 < $1})
	}
}
