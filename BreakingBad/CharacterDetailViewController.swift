//
//  CharacterDetailViewController.swift
//  BreakingBad
//
//  Created by Sepandat Pourtaymour on 18/02/2021.
//  Copyright © 2021 Sepandat Pourtaymour. All rights reserved.
//

import UIKit
import EasyPeasy

class CharacterDetailViewController: UIViewController {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var nicknameLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var infoStack: UIStackView!
	
	func configure(character: Character) {
		nameLabel.text = character.name
		nicknameLabel.text = "AKA \(character.nickname)"
		imageView.imageFromServerURL(item: character)
		
		let occupationStack = createDetailSubStack(title: "Occupation", detail: character.occupation.joined(separator: ", "))
		
		let statusStack = createDetailSubStack(title: "Status", detail: character.status)

		let reducedSeasons = character.appearance
			.sorted(by: { $0 < $1 })
			.reduce("") { (current, next) -> String in
				if current.isEmpty {
					return current.appending("\(next)")
				}
				return current.appending(", \(next)")
		}
		let appearanceStack = createDetailSubStack(title: "Appeared in Seasons", detail: reducedSeasons)

		[occupationStack, statusStack, appearanceStack].forEach {
			infoStack.addArrangedSubview($0)
		}
		
		infoStack.addArrangedSubview(UIView())
	}
	
	func createDetailSubStack(title: String, detail: String) -> UIStackView {
		let subStack = UIStackView()
		subStack.axis = .vertical
		subStack.spacing = 5
		let titleLabel = UILabel()
		titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
		titleLabel.textAlignment = .center
		titleLabel.numberOfLines = 1
		titleLabel.text = title
		
		subStack.addArrangedSubview(titleLabel)
		
		let informationLabel = UILabel()
		informationLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		informationLabel.textAlignment = .center
		informationLabel.numberOfLines = 2
		informationLabel.text = detail

		subStack.addArrangedSubview(informationLabel)

		return subStack
	}
}
