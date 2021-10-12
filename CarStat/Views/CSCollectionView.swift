//
//  CSCollectionView.swift
//  CarStat
//
//  Created by Aleksey Mironov on 13.09.2021.
//


import UIKit

class CSCollectionView: UICollectionView {}

extension CSCollectionView {
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        keyboardDismissMode = .onDrag
        
        register(cellType: RefuelingInfoCell.self)
        register(cellType: CSButtonCell.self)
        register(cellType: CSTextCell.self)
        register(cellType: CSInputCell.self)
        register(cellType: CSDateInputCell.self)
    }
}

