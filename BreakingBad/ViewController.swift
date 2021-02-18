//
//  ViewController.swift
//  BreakingBad
//
//  Created by Sepandat Pourtaymour on 15/02/2021.
//  Copyright © 2021 Sepandat Pourtaymour. All rights reserved.
//

import EasyPeasy
import UIKit

class ViewController: UIViewController {

	var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.backgroundColor = .clear
		return cv
	}()
		
	var model: CharacterFetchable?
	var viewModel = CharacterViewModel()
	
	let searchController = UISearchController(searchResultsController: nil)
	var filteredComponents = [Character]()
	var isSearchBarEmpty: Bool { searchController.searchBar.text?.isEmpty ?? true }
	var isFiltering: Bool { searchController.isActive && !isSearchBarEmpty }
	var contentToUse: [Character] {
		var toRet: [Character]?
		if isFiltering {
			toRet = model?.filteredContents
		} else {
			toRet = model?.fetchedContents
		}
		
		return toRet ?? []
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = viewModel.backgroundColor
		
		view.addSubview(collectionView)
		collectionView.easy.layout(Edges(viewModel.collectionViewPadding))
		
		model = CharacterFetchModel(networkManager: NetworkManager())
		
		setupNavigationAndSearch()
		
		collectionView.delegate = self
		collectionView.dataSource = self
		viewModel.registerCell(collectionView: collectionView)
		model?.fetchCharacters { result in
			if let _ = try? result.get() {
				self.shouldRefreshDatabase()
			}
		}
	}
	
	func setupNavigationAndSearch() {
		self.title = "Characters"
		let filterButton = UIBarButtonItem(title: "Seasons", style: .plain, target: self, action: #selector(selectSeason(barItem:)))
		searchController.searchResultsUpdater = self
		viewModel.configure(navigationItem: navigationItem, filterButton: filterButton, searchController: searchController)
	}

	@objc
	func selectSeason(barItem: UIBarButtonItem) {
		guard let seasons = model?.fetchAllSeasons() else { return }
		let alertVC = UIAlertController(title: "Select a season", message: "Select one of the available seasons", preferredStyle: .actionSheet)
		
		seasons.forEach({ season in
			alertVC.addAction(UIAlertAction(title: "Season \(season)", style: .default, handler: { (action) in
				self.model?.updateWithSeason(season: season, completion: { (selected) in
					self.title = "Season \(season)"
					self.shouldRefreshDatabase()
				})
			}))
		})
		
		alertVC.addAction(UIAlertAction(title: "All", style: .default, handler: { (action) in
				self.model?.updateWithSeason(season: nil, completion: { (selected) in
					self.title = "Characters"
				self.shouldRefreshDatabase()
			})
		}))

		alertVC.popoverPresentationController?.barButtonItem = barItem

		present(alertVC, animated: true, completion: nil)
	}

	func shouldRefreshDatabase() {
		DispatchQueue.main.async {
			self.collectionView.reloadData()
		}
	}
}

extension ViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let character = model?.character(indexPath: indexPath, isSearching: isFiltering) else { return }
		let detailCoordinator = CharacterDetailCoordinator(presenter: self, character: character)
		(UIApplication.shared.delegate as! AppDelegate).currentCoordinator = detailCoordinator
		detailCoordinator.start()
	}
}

extension ViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		let searchBar = searchController.searchBar
		model?.filterContentForSearchText(searchBar.text, completion: { (success) in
			self.shouldRefreshDatabase()
		})
	}
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return viewModel.cellSize
	}
	
//	func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//		(cell as? CharacterCell)?.prepareForReuse()
//	}
//	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return viewModel.cellPadding(for: view.frame.size)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return viewModel.sectionInset(for: view.frame.size, section: section)
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return contentToUse.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CharacterCell
		
		if contentToUse.count > 0 {
			cell.configure(character: contentToUse[indexPath.row], fontColor: viewModel.fontColor, font: viewModel.titleFont)
		}
		return cell
	}
	
	
}

