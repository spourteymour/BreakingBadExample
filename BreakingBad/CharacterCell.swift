//
//  CharacterCell.swift
//  BreakingBad
//
//  Created by Sepandat Pourtaymour on 16/02/2021.
//  Copyright © 2021 Sepandat Pourtaymour. All rights reserved.
//

import UIKit

class CharacterCell: UICollectionViewCell {

	@IBOutlet weak var packshotImage: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func configure(character: Character, fontColor: UIColor, font: UIFont) { //TODO: Move all the styling properties to a separate struct, and pass it from viewmodel.
		packshotImage.imageFromServerURL(item: character)
		titleLabel.text = character.name
		titleLabel.font = font
		titleLabel.textColor = fontColor
	}
	
	override func prepareForReuse() {
		packshotImage.image = nil
		packshotImage.setNeedsDisplay()
		titleLabel.text = ""
	}
}
