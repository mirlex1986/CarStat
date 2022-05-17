//
//  CSViewController.swift
//  CarStat
//
//  Created by Aleksey Mironov on 26.04.2022.
//

import UIKit
import RxSwift
import RxCocoa

class CSViewController: UIViewController {
    // MARK: - UI
    private var viewLoader: UIImageView!
    var containerView: UIView!
    
    var viewTapGesture: UITapGestureRecognizer!
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var isPresentedModally: Bool = false
    
    private var tabBarHeight: CGFloat {
        if let tabBar = self.tabBarController?.tabBar, !tabBar.isHidden {
            return tabBar.frame.height
        } else {
            return 0
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
    }
}

extension CSViewController {
    @objc func makeUI() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        // CONTAINER VIEW
        containerView = UIView()
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.size.equalToSuperview()
            $0.bottom.equalToSuperview().offset(100)
        }
        
        // TAP GESTURE RECOGNISER
        viewTapGesture = UITapGestureRecognizer()
        viewTapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(viewTapGesture)
    }
}

// MARK: - Public cells
extension CSViewController {
    public func emptyCell(_ collectionView: CSCollectionView, indexPath: IndexPath, color: UIColor = .clear) -> CSCollectionViewCell {
        let cell: CSEmptyCell = collectionView.cell(indexPath: indexPath)
        cell.configure(color: color)

        return cell
    }
    
    public func textCell(_ collectionView: CSCollectionView,
                         indexPath: IndexPath,
                         text: String,
                         color: UIColor = .darkText,
                         alignment: NSTextAlignment = .left) -> CSCollectionViewCell {
        let cell: CSTextCell = collectionView.cell(indexPath: indexPath)
        cell.configure(text: text, textColor: color, textAlignment: alignment)
        
        return cell
    }
}
