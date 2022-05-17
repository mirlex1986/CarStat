//
//  AppDelegate.swift
//  CarStat
//
//  Created by Aleksey Mironov on 13.09.2021.
//

import UIKit
import RealmSwift
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                
            })
        Realm.Configuration.defaultConfiguration = config
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = CSTabBarController()
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        
        return true
    }
}

