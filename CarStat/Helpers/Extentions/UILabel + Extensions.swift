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
    
    func makeAttributedStringForAverageData(for strings: [String], and underlinedText: String) {
        let attrs1 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                      NSAttributedString.Key.foregroundColor: UIColor.black]
        let attrs2 = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
                      NSAttributedString.Key.underlineStyle: 1,
                      NSAttributedString.Key.foregroundColor: UIColor.black] as [NSAttributedString.Key : Any]

        let attributedString1 = NSMutableAttributedString(string: strings[0], attributes: attrs1)
        let attributedString2 = NSMutableAttributedString(string: underlinedText, attributes: attrs2)
        let attributedString3 = NSMutableAttributedString(string: strings[1], attributes: attrs1)
        attributedString2.append(attributedString3)
        attributedString1.append(attributedString2)
        attributedText = attributedString1
    }
    
    func setFontSize(size: CGFloat = 14) {
        self.font = UIFont.systemFont(ofSize: size)
    }
    
}
