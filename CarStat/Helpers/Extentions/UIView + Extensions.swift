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
    }
}

// MARK: - Animation
extension UIView {
    static private let rotationAnimationName = "rotationAnimation"
    
    func rotate(with duration: Double = 0.7) {
        let rotation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.toValue = Double.pi * 2
        rotation.duration = duration
        rotation.repeatCount = .infinity
        layer.add(rotation, forKey: UIView.rotationAnimationName)
    }

    func stopRotating() {
        layer.removeAnimation(forKey: UIView.rotationAnimationName)
    }
}
