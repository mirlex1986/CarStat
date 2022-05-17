//
//  CSEmptyCell.swift
//  CarStat
//
//  Created by Aleksey Mironov on 26.04.2022.
//

import UIKit
import SnapKit

final class CSEmptyCell: RxCollectionViewCell {
    // MARK: - UI
    private var colorView: UIView!
    
    // MARK: - Lifecycle
    override func initialSetup() {
        super.initialSetup()
        
        makeUI()
    }
    
    func configure(color: UIColor = .clear) {
        colorView.backgroundColor = color
    }
}

extension CSEmptyCell {
    private func makeUI() {
        backgroundColor = .clear
        
        // COLOR VIEW
        colorView = UIView()
        addSubview(colorView)
        colorView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(-16)
            $0.top.bottom.equalToSuperview()
        }
    }
}

extension CSEmptyCell {
    static func cellSize(height: CGFloat) -> CGSize {
        return CGSize(width: Device.deviceWidth - 32, height: height)
    }
}
