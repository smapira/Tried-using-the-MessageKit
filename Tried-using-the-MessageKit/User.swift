//
//  User.swift
//  Tried-using-the-MessageKit
//
//  Created by bookpro on 2021/08/01.
//  Copyright © 2021 routeflags. All rights reserved.
//

import Foundation

struct User {
	let uid: UUID
	let name: String
	
	init(name: String) {
		self.name = name
		self.uid = UUID()
	}
}
