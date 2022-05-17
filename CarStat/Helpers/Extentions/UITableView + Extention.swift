//
//  UITableView + Extention.swift
//  CarStat
//
//  Created by Aleksey Mironov on 27.04.2022.
//

import RxSwift
import RxCocoa

extension UITableView {
    func cell<T: UITableViewCell>(forClass cellClass: T.Type = T.self, indexPath: IndexPath) -> T {
        let className = String(describing: cellClass)
        guard let cell = dequeueReusableCell(withIdentifier: className, for: indexPath) as? T else { return T() }
        return cell
    }
    
    func register<T: UITableViewCell>(cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: String(describing: cellType))
//        register(cellType, forCellWithReuseIdentifier: String(describing: cellType))
    }
}
