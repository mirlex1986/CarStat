//
//  UIView + Extensions.swift
//  CarStat
//
//  Created by Aleksey Mironov on 16.05.2022.
//

import UIKit

extension UIView {
    
    // MARK: - Functions
    func setCornerRadius(_ radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func setBorder(width: CGFloat = 0.25) {
        self.layer.borderWidth = width
        self.layer.borderColor = CGColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
    }
    
    public func setViewSettingWithBgShade(color: UIColor) {
        self.layer.cornerRadius = 3
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
        self.layer.shadowColor = color.cgColor
//        self.layer.masksToBounds = false
        setBorder()
    }
}
