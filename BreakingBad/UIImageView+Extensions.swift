//
//  UIImageView+Extensions.swift
//  BreakingBad
//
//  Created by Sepandat Pourtaymour on 17/02/2021.
//  Copyright © 2021 Sepandat Pourtaymour. All rights reserved.
//

import UIKit

extension UIImageView {
	func imageFromServerURL(item: ImageCachable) {
		self.image = nil
		ImageCache.publicCache.load(item: item) { (fetchedItem, image) in
			if let img = image {
				DispatchQueue.main.async(execute: { () -> Void in
					self.image = img
					self.setNeedsDisplay()
				})
			}
		}
		
	}
}

