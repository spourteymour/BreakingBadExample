//
//  CharacterViewModel.swift
//  BreakingBad
//
//  Created by Sepandat Pourtaymour on 16/02/2021.
//  Copyright © 2021 Sepandat Pourtaymour. All rights reserved.
//

import UIKit

struct CharacterViewModel {
	var cellSize = CGSize(width: 140, height: 200)
	var backgroundColor = UIColor.with(hexValue: "006048")
	var fontColor = UIColor.with(hexValue: "78c018")
	var titleFont = UIFont.systemFont(ofSize: 14, weight: .heavy)
	var collectionViewPadding: CGFloat = 0
	
	func cellPadding(for superViewSize: CGSize) -> CGFloat {
		let difference = superViewSize.width.truncatingRemainder(dividingBy: cellSize.width)
		let width = difference / CGFloat(Int((superViewSize.width / cellSize.width) + 1))
		return width
	}
	
	func registerCell(collectionView: UICollectionView) {
		collectionView.register(UINib(nibName: "CharacterCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
	}

	func sectionInset(for superViewSize: CGSize, section: Int) -> UIEdgeInsets {
		let padding = cellPadding(for: superViewSize)
		return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
	}

	
	func configure(navigationItem: UINavigationItem, filterButton: UIBarButtonItem, searchController: UISearchController? = nil) {
		navigationItem.setRightBarButton(filterButton, animated: false)
//		navigationItem.hidesSearchBarWhenScrolling = false

		searchController?.obscuresBackgroundDuringPresentation = false
		searchController?.searchBar.placeholder = "Search Characters"
		searchController?.hidesNavigationBarDuringPresentation = true
		navigationItem.searchController = searchController
	}
	
}
