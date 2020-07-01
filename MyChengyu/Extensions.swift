//
//  Extensions.swift
//  MyChengyu
//
//  Created by Antoine on 01/07/2020.
//  Copyright © 2020 BOUBERBOUCHE Antoine. All rights reserved.
//

import UIKit

extension UISearchBar {
    func setIconsColor(to color: UIColor) {
        if let textField = value(forKey: "searchField") as? UITextField {
            if let leftImageView = textField.leftView as? UIImageView {
                leftImageView.image = leftImageView.image?.withRenderingMode(.alwaysTemplate)
                leftImageView.tintColor = color
            }
            if let rightImageView = textField.leftView as? UIImageView {
                rightImageView.image = rightImageView.image?.withRenderingMode(.alwaysTemplate)
                rightImageView.tintColor = color
            }
        }
    }
}

extension UIFont {
    static func roundedFont(ofSize style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        // Will be SF Compact or standard SF in case of failure.
        let fontSize = UIFont.preferredFont(forTextStyle: style).pointSize
        if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: fontSize)
        } else {
            return UIFont.preferredFont(forTextStyle: style)
        }
    }
    
    static func roundedFont(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        // Will be SF Compact or standard SF in case of failure.
        if let descriptor = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: size)
        } else {
            return UIFont.preferredFont(forTextStyle: .caption1)
        }
    }
}

extension UIColor {
    static let chengyuRed = UIColor(displayP3Red: 219/255, green: 90/255, blue: 100/255, alpha: 1)
    static let chengyuWhite = UIColor(displayP3Red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    static let chengyuBlack = UIColor(displayP3Red: 20/255, green: 20/255, blue: 20/255, alpha: 1)
}


extension UIAlertController {
    func setTheme() {
        self.view.tintColor = UIColor(named: "GameControl")
    }
}

