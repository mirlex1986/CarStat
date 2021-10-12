//
//  AppDelegate.swift
//  CarStat
//
//  Created by Aleksey Mironov on 13.09.2021.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 0,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                
            })
        Realm.Configuration.defaultConfiguration = config
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainScreenViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}

