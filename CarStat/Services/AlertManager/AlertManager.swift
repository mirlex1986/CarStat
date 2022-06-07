import UIKit

final class AlertManager {
    
    static func showAction(on: UIViewController, title: String, message: String, comlition: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let save = UIAlertAction(title: "Save", style: .default) { _ in
            comlition(true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            comlition(false)
        }
        alertController.addAction(save)
        alertController.addAction(cancel)

        on.present(alertController, animated: true)
    }
}
