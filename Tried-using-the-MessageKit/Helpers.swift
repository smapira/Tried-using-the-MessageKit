//
//  Helpers.swift
//  Tried-using-the-MessageKit
//
//  Created by bookpro on 2021/08/01.
//  Copyright © 2021 routeflags. All rights reserved.
//

import UIKit

func generateRandomData() -> [UIColor] {
	let numberOfRows = 20
	
	return (0..<numberOfRows).map { _ in UIColor.randomColor() }
}

extension UIColor {
	
	class func randomColor() -> UIColor {
		
		let hue = CGFloat(arc4random() % 100) / 100
		let saturation = CGFloat(arc4random() % 100) / 100
		let brightness = CGFloat(arc4random() % 100) / 100
		
		return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
	}
}

extension UIView {
	func anchor(top: NSLayoutYAxisAnchor? = nil,
				left: NSLayoutXAxisAnchor? = nil,
				bottom: NSLayoutYAxisAnchor? = nil ,
				right: NSLayoutXAxisAnchor? = nil ,
				paddingTop: CGFloat = 0 ,
				paddingLeft: CGFloat = 0 ,
				paddingBottom: CGFloat = 0 ,
				paddingRight: CGFloat = 0 ,
				width: CGFloat = 0 ,
				height: CGFloat = 0) {
		
		translatesAutoresizingMaskIntoConstraints = false
		
		if let top = top {
			topAnchor.constraint(equalTo: top,
								 constant: paddingTop).isActive = true
		}
		if let left = left {
			leftAnchor.constraint(equalTo: left,
								  constant: paddingLeft).isActive = true
		}
		if let bottom = bottom {
			bottomAnchor.constraint(equalTo: bottom,
									constant: -paddingBottom).isActive = true
		}
		if let right = right {
			rightAnchor.constraint(equalTo: right,
								   constant: -paddingRight).isActive = true
		}
		if width != 0 {
			widthAnchor.constraint(equalToConstant: width).isActive = true
		}
		if height != 0 {
			heightAnchor.constraint(equalToConstant: height).isActive = true
		}
	}
}
