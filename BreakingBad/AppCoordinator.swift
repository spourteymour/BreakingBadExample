//
//  AppCoordinator.swift
//  BreakingBad
//
//  Created by Sepandat Pourtaymour on 15/02/2021.
//  Copyright © 2021 Sepandat Pourtaymour. All rights reserved.
//

import UIKit


protocol Coordinator {
	func start()
}


class CharacterDetailCoordinator: Coordinator {
	
	var presenter: UIViewController
	var character: Character
	
	init(presenter: UIViewController, character: Character) {
		self.presenter = presenter
		self.character = character
	}
	
	func start() {
		if let viewcontroller = UIStoryboard(name: "CharacterDetails", bundle: nil).instantiateInitialViewController() as? CharacterDetailViewController {
			presenter.present(viewcontroller, animated: true) {
				viewcontroller.configure(character: self.character)
			}
		}
	}
}
