//
//  RefuelingCell.swift
//  CarStat
//
//  Created by Aleksey Mironov on 13.05.2022.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RefuelingCell: RxCollectionViewCell {
    private var titleLabel: UILabel!
    private var cellView: UIView!
    
    private var averageView: UIView!
    private var averageLabel: UILabel!
    
    private var totalsStackView: UIStackView!
    
    private var totalLitersView: UIView!
    private var totalLitersTitleLabel: UILabel!
    private var totalLitersValueLabel: UILabel!
    
    private var totalMoneyView: UIView!
    private var totalMoneyTitleLabel: UILabel!
    private var totalMoneyValueLabel: UILabel!

    // MARK: - Lifecycle
    override func initialSetup() {
        super.initialSetup()
        
        makeUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func configure(with data: [UserMileage]) {
        var tempLiters = 0.0
        var tempMileage = 0.0
        
        data.forEach {
            if let ref = $0.data.refueling, let quantity = ref.quantity {
                tempLiters += quantity
                
                if let rub = ref.totalPrice {
                    tempMileage += rub
                }
            }
        }
        let refs = data.filter { $0.refueling?.quantity ?? 0.0 > 0 }
        
        if let first = refs.first?.odometer, let last = refs.last?.odometer {
            let rounded = tempLiters / Double(first - last) * 100
            averageLabel.makeAttributedStringForAverageData(for: ["Средний расход: ",
                                                                       " л/100км"],
                                                                 and: "\(round(rounded * 100) / 100.0)")
        }
        
        if refs.isEmpty {
            averageLabel.makeAttributedStringForAverageData(for: ["Нет данных о заправках", ""], and: "")
        }
        
        let total = round(tempMileage * 100) / 100.0
        totalMoneyValueLabel.text = "\(total) руб."
        totalLitersValueLabel.text = "\(tempLiters) л."

        cellView.snp.updateConstraints {
            $0.height.equalTo(contentView.frame.height)
        }
    }
}

extension RefuelingCell {
    private func makeUI() {
        backgroundColor = .clear
        
        titleLabel = UILabel()
        titleLabel.textColor = .darkGray
        titleLabel.text = "Топливо"
        titleLabel.setFontSize(size: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
        }
        
        cellView = UIView()
        cellView.backgroundColor = .clear
        cellView.clipsToBounds = true
        cellView.setBorder()
        cellView.setCornerRadius(15)
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(114)
        }
        
        averageView = UIView()
        averageView.setCornerRadius(15)
        averageView.backgroundColor = .lightBlue
        cellView.addSubview(averageView)
        averageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(8)
            $0.height.equalTo(50)
        }
        
        averageLabel = UILabel()
        averageLabel.setFontSize(size: 14)
        averageView.addSubview(averageLabel)
        averageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        totalsStackView = UIStackView()
        totalsStackView.axis = .horizontal
        totalsStackView.distribution = .fillEqually
        totalsStackView.spacing = 10
        cellView.addSubview(totalsStackView)
        totalsStackView.snp.makeConstraints {
            $0.top.equalTo(averageView.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(8)
        }
        
        totalLitersView = UIView()
        totalLitersView.setCornerRadius(15)
        totalLitersView.backgroundColor = .lightBlue
        totalsStackView.addArrangedSubview(totalLitersView)
        totalLitersView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        totalLitersTitleLabel = UILabel()
        totalLitersTitleLabel.text = "Всего залито:"
        totalLitersTitleLabel.setFontSize(size: 14)
        totalLitersView.addSubview(totalLitersTitleLabel)
        totalLitersTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
        }
        
        totalLitersValueLabel = UILabel()
        totalLitersValueLabel.textColor = .black
        totalLitersValueLabel.setFontSize(size: 15)
        totalLitersView.addSubview(totalLitersValueLabel)
        totalLitersValueLabel.snp.makeConstraints {
            $0.top.equalTo(totalLitersTitleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        totalMoneyView = UIView()
        totalMoneyView.setCornerRadius(15)
        totalMoneyView.backgroundColor = .lightBlue
        totalsStackView.addArrangedSubview(totalMoneyView)
        totalMoneyView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        totalMoneyTitleLabel = UILabel()
        totalMoneyTitleLabel.text = "На сумму:"
        totalMoneyTitleLabel.isHighlighted = true
        totalMoneyTitleLabel.setFontSize(size: 14)
        totalMoneyView.addSubview(totalMoneyTitleLabel)
        totalMoneyTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
        }
        
        totalMoneyValueLabel = UILabel()
        totalMoneyValueLabel.textColor = .black
        totalMoneyValueLabel.setFontSize(size: 15)
        totalMoneyView.addSubview(totalMoneyValueLabel)
        totalMoneyValueLabel.snp.makeConstraints {
            $0.top.equalTo(totalMoneyTitleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
}

extension RefuelingCell {
    static var cellSize: CGSize { CGSize(width: UIScreen.main.bounds.width - 32, height: 120) }
}

