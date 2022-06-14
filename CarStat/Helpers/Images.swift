import UIKit

enum Images {
    static var loader: UIImage { UIImage(named: "loader") ?? UIImage() }
    
    static var backButton: UIImage { UIImage(named: "backBtn")?.withRenderingMode(.alwaysTemplate) ?? UIImage() }
    static var close: UIImage { UIImage(named: "close")?.withRenderingMode(.alwaysTemplate) ?? UIImage() }
    
    static var service: UIImage { UIImage(named: "service")?.withRenderingMode(.alwaysTemplate) ?? UIImage() }
    static var fuel: UIImage { UIImage(named: "fuel")?.withRenderingMode(.alwaysTemplate) ?? UIImage() }
    static var odometer: UIImage { UIImage(named: "odometer")?.withRenderingMode(.alwaysTemplate) ?? UIImage() }
}
