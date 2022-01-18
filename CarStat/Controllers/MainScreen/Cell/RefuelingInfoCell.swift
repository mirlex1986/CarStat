//
//  RefuelingInfoCell.swift
//  CarStat
//
//  Created by Aleksey Mironov on 17.09.2021.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SwiftUI

class RefuelingInfoCell: RxCollectionViewCell {
    private var cellView: UIView!
    private var dateLabel: UILabel!
    private var odometerLabel: UILabel!
    
    // MARK: - Lifecycle
    override func initialSetup() {
        super.initialSetup()
        
        makeUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func configure(mileage: UserMileage) {
        let data = DateFormatter()
        data.dateFormat = "dd MMM yyyy"
        data.locale = Locale(identifier: "ru_RU")

        dateLabel.text = "Дата: \(data.string(from: mileage.date))"
        odometerLabel.text = "Пробег \(mileage.odometer) км"
    }
}

extension RefuelingInfoCell {
    private func makeUI() {
        backgroundColor = .clear
        
        cellView = UIView()
        cellView.backgroundColor = .clear
        cellView.layer.borderWidth = 0.25
        cellView.layer.borderColor = CGColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1)
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(55)
        }
        
        dateLabel = UILabel()
        dateLabel.textColor = .black
        cellView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.left.right.equalToSuperview().inset(16)
        }
        
        odometerLabel = UILabel()
        odometerLabel.textColor = .blue
        cellView.addSubview(odometerLabel)
        odometerLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom)
            $0.left.right.equalToSuperview().inset(16)
        }
        
    }
}

extension RefuelingInfoCell {
    static var cellSize: CGSize { CGSize(width: UIScreen.main.bounds.width, height: 55) }
}
