//
//  UILabel + Extensions.swift
//  CarStat
//
//  Created by Aleksey Mironov on 26.04.2022.
//

import UIKit

extension UILabel {
    func setTextSpacingBy(value: Double) {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: value, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
    
    func heightThatFitsFor(width: CGFloat) -> CGFloat {
        let size = sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        return size.height
    }
    
    func widthThatFitsFor(height: CGFloat) -> CGFloat {
        let size = sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: height))
        return size.width
    }
    
    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
    
    static func calculateHeight(for text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = font
        return label.heightThatFitsFor(width: width)
    }
    
    static func calculateHeight(for attributedText: NSAttributedString, font: UIFont, width: CGFloat) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = attributedText
        label.font = font
        return label.heightThatFitsFor(width: width)
    }
//
//    func diagonalStrikeThrough(bounds: CGRect? = nil, offsetPercent: CGFloat = 0.1, withoutCurrency: Bool = true) {
//        let bounds = bounds ?? self.bounds
//
//        let currencyWidth = withoutCurrency
//            ? UILabel.textWidth(font: UIFont.avenirNext(style: .demiBold, size: 13), text: " ₽") : 0
//
//        let linePath = UIBezierPath()
//        linePath.move(to: CGPoint(x: 0, y: bounds.height * (1 - offsetPercent)))
//        linePath.addLine(to: CGPoint(x: bounds.width - currencyWidth, y: bounds.height * offsetPercent))
//
//        let borderPath = UIBezierPath()
//        borderPath.move(to: CGPoint(x: 0, y: bounds.height * (1 - offsetPercent)))
//        borderPath.addLine(to: CGPoint(x: bounds.width - currencyWidth, y: bounds.height * offsetPercent))
//
//        let borderLayer = CAShapeLayer()
//        borderLayer.path = borderPath.cgPath
//        borderLayer.lineWidth = 1.8
//        borderLayer.strokeColor = UIColor.white.cgColor
//        layer.addSublayer(borderLayer)
//
//        let lineLayer = CAShapeLayer()
//        lineLayer.path = linePath.cgPath
//        lineLayer.lineWidth = 1
//        lineLayer.strokeColor = textColor.cgColor
//        layer.addSublayer(lineLayer)
//    }
//
//    static func lgLabel(font: UIFont = .avenirNext(style: .regular, size: 17),
//                        color: UIColor = .brandMain2,
//                        tag: Int? = nil) -> UILabel {
//        let label = UILabel()
//        label.font = font
//        label.textColor = color
//        if let tag = tag {
//            label.tag = tag
//        }
//        return label
//    }
}
