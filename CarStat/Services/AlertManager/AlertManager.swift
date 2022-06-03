//
//  AlertManager.swift
//  CarStat
//
//  Created by Aleksey Mironov on 03.06.2022.
//

import UIKit

final class AlertManager {
    
    static func showAction(on: UIViewController, title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let save = UIAlertAction(title: "Save", style: .default)
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        on.present(alertController, animated: true)
    }
}
