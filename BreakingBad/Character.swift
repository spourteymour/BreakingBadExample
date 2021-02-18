//
//  Character.swift
//  BreakingBad
//
//  Created by Sepandat Pourtaymour on 15/02/2021.
//  Copyright © 2021 Sepandat Pourtaymour. All rights reserved.
//

import Foundation

struct Character: Codable {
	let char_id: Int
	let name: String
	let birthday: String
	let img: String
	let occupation: [String]
	let status: String
	let nickname: String
	let appearance: [Int]
}

extension Character: ImageCachable {
	var url: String { img }
	var cacheId: String { "\(char_id)" }
}
