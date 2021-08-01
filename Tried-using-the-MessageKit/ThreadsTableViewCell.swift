//
//  ThreadsTableViewCell.swift
//  Tried-using-the-MessageKit
//
//  Created by bookpro on 2021/08/01.
//  Copyright © 2021 routeflags. All rights reserved.
//

import UIKit

class ThreadsTableViewCell: UITableViewCell {
	static let reuseIdentifier = String(describing: ThreadsTableViewCell.self)
	
	override init(style: UITableViewCell.CellStyle,
				  reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
