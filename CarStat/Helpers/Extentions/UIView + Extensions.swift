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
    
//    func rotate(angle: CGFloat) {
//        let radians = 90 / 180.0 * CGFloat.pi
//        let rotation = self.transform.rotated(by: radians);
//        self.transform = rotation
//    }
}

// MARK: - Animation
extension UIView {
    private static let kRotationAnimationKey = "rotationanimationkey"

    func rotate(duration: Double = 1) {
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity

            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }

    func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }
}
