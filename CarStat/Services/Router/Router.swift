//
//  Router.swift
//  CarStat
//
//  Created by Aleksey Mironov on 19.05.2022.
//

import RxSwift
import RxCocoa
import UIKit

enum Router {
    case addRefueling(lastRefueling: UserMileage?, isEditing: Bool = false)
}

extension Router {
    // MARK: - Push
    func push(from navigationController: UINavigationController?, animated: Bool = true) {
        switch self {
        case .addRefueling(let lastRefueling, let isEditing):
            let vc = AddMileageViewController()
            vc.viewModel = AddMileageViewModel(lastMileage: lastRefueling, isEditing: isEditing)
            
            navigationController?.pushViewController(vc, animated: animated)
        
//        default:
//            return
        }
    }
    
    // MARK: - Present
//    func present(from viewController: UIViewController?,
//                 animated: Bool = true,
//                 modalTransitionStyle: UIModalTransitionStyle = .coverVertical,
//                 modalPresentationStyle: UIModalPresentationStyle = .fullScreen) {
//
//        var presentedViewController: UIViewController?
//
//        switch self {
//
//        default: return
//        }
//
//        guard let vc = presentedViewController else { return }
//        vc.modalTransitionStyle = modalTransitionStyle
//        vc.modalPresentationStyle = modalPresentationStyle
//        viewController?.present(vc, animated: animated)
//    }
}
