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
    private var image: UIImageView!
    private var dateLabel: UILabel!
    private var mileageLabel: UILabel!
    private var odometerLabel: UILabel!
    private var refuelingTotalPrice: UILabel!
    
    // MARK: - Lifecycle
    override func initialSetup() {
        super.initialSetup()
        
        makeUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func configure(mileage: UserMileage, previos: Int) {
        if let date = Formatters.dateApi.date(from: mileage.date) {
            let dateString = Formatters.dateLongOutput.string(from: date)
            dateLabel.text = "\(dateString)"
        }

        if let totalPrice = mileage.data.refueling?.totalPrice, !totalPrice.isZero {
            refuelingTotalPrice.text = "\(totalPrice) ₽"
            image.image = Images.fuel.withRenderingMode(.alwaysTemplate)
            
            odometerLabel.snp.remakeConstraints {
                $0.top.equalTo(refuelingTotalPrice.snp.bottom).offset(4)
                $0.right.equalToSuperview().inset(16)
            }
            
        }
        
        if (mileage.odometer - previos) > 0 {
            mileageLabel.isHidden = false
            mileageLabel.text = "\(mileage.odometer - previos) км"
            
            dateLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().inset(4)
                $0.left.equalTo(image.snp.right).offset(8)
            }
        }
        odometerLabel.text = "\(mileage.odometer) км"
        
    }
}

extension RefuelingInfoCell {
    private func makeUI() {
        backgroundColor = .clear
        
        cellView = UIView()
        cellView.backgroundColor = .clear
        cellView.clipsToBounds = true
        cellView.setBorder()
        cellView.setCornerRadius(15)
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        image = UIImageView()
        image.image = Images.odometer.withRenderingMode(.alwaysTemplate)
        image.tintColor = .lightBlue
        cellView.addSubview(image)
        image.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(8)
            $0.size.equalTo(30)
        }
        
        dateLabel = UILabel()
        dateLabel.textColor = .black
        dateLabel.setFontSize(size: 16)
        cellView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(image.snp.right).offset(8)
        }
        
        mileageLabel = UILabel()
        mileageLabel.setFontSize(size: 14)
        mileageLabel.textColor = .lightGray
        mileageLabel.isHidden = true
        cellView.addSubview(mileageLabel)
        mileageLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(2)
            $0.left.equalTo(image.snp.right).offset(8)
        }
        
        refuelingTotalPrice = UILabel()
        refuelingTotalPrice.textAlignment = .right
        refuelingTotalPrice.font = UIFont.systemFont(ofSize: 14)
        cellView.addSubview(refuelingTotalPrice)
        refuelingTotalPrice.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.right.equalToSuperview().inset(14)
        }
        
        odometerLabel = UILabel()
        odometerLabel.textColor = .lightGray
        odometerLabel.setFontSize(size: 14)
        cellView.addSubview(odometerLabel)
        odometerLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(16)
        }
    }
}

extension RefuelingInfoCell {
    static var cellSize: CGSize { CGSize(width: UIScreen.main.bounds.width - 32, height: 52) }
}
