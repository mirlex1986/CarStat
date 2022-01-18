//
//  CSChartCell.swift
//  CarStat
//
//  Created by Aleksey Mironov on 12.10.2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Charts

class CSChartCell: RxCollectionViewCell {
    private var mainView: UIView!
    private var chart: BarChartView!
    
    // MARK: - Lifecycle
    override func initialSetup() {
        super.initialSetup()
        
        makeUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func configure(mileages: [UserMileage]) {
        var dataEntries: [ChartDataEntry] = []
        
    }
}

extension CSChartCell {
    private func makeUI() {
        backgroundColor = .clear
        
        mainView = UIView()
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        chart = BarChartView()
        mainView.addSubview(chart)
        chart.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension CSChartCell {
    static var cellSize: CGSize { CGSize(width: UIScreen.main.bounds.width - 32, height: 260) }
}

