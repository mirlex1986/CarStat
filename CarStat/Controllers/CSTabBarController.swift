//
//  CSTabBarController.swift
//  CarStat
//
//  Created by Aleksey Mironov on 18.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

enum TabBarItem: Int {
    case home
    case gas
    case service
}

// MARK: - Main
final class CSTabBarController: UITabBarController {
    //MARK: - Properties
    let disposeBag = DisposeBag()
    
    let tabBarTapped = PublishRelay<Int>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        setupUI()
        subscribe()
        setupBorder(isHidden: false)
        setupTabBarControllers()
    }

    // MARK: - Functions
    private func subscribe() {

    }
    
    private func setupTabBarControllers() {
        let items = [createNavController(for: HomeViewController()),
                     createNavController(for: RefuelingViewController()),
                     createNavController(for: ServicesViewController())]
    
        viewControllers = items
    }
    
    private func createNavController(for rootViewController: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.setNavigationBarHidden(true, animated: false)
        
        var icon: UIImage?
        var title: String?
        
        switch rootViewController {
        case is HomeViewController:
            title = "Статистика"
            icon = UIImage(systemName: "chart.bar")
            navController.tabBarItem.selectedImage = UIImage(systemName: "chart.bar.fill")?.withRenderingMode(.alwaysTemplate)
        case is RefuelingViewController:
            title = "Топливо"
            icon = UIImage(systemName: "flame")
            navController.tabBarItem.selectedImage = UIImage(systemName: "flame.fill")?.withRenderingMode(.alwaysTemplate)
        case is ServicesViewController:
            title = "Сервис"
            icon = UIImage(systemName: "tray.circle")
            navController.tabBarItem.selectedImage = UIImage(systemName: "tray.circle.fill")?.withRenderingMode(.alwaysTemplate)
        default:
            break
        }

        navController.tabBarItem.title = title
        navController.tabBarItem.image = icon?.withRenderingMode(.alwaysTemplate)
        
        
        return navController
    }
}

extension CSTabBarController {
    private func setupUI() {
        tabBar.barTintColor = .white
        tabBar.tintColor = .lightBlue.withAlphaComponent(1)
        tabBar.unselectedItemTintColor = UIColor.black.withAlphaComponent(0.4)
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .white
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)],
            for: .normal
        )
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)],
            for: .selected
        )
    }
    
    func setupBorder(isHidden: Bool) {
        tabBar.layer.borderWidth = isHidden ? 0 : 0.5
        tabBar.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        tabBar.clipsToBounds = true
    }
    
    func switchToTab(_ item: TabBarItem) {
        self.selectedIndex = item.rawValue
    }
}

extension CSTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        tabBarTapped.accept(tabBarController.selectedIndex)
        return true
    }
}


