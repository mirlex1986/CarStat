import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MileageCell: RxCollectionViewCell {
    private var titleLabel: UILabel!
    private var cellView: UIView!
    
    private var averageView: UIView!
    private var averageLabel: UILabel!
    
    private var totalsStackView: UIStackView!
    
    private var totalDaysView: UIView!
    private var totalDaysTitleLabel: UILabel!
    private var totalDaysValueLabel: UILabel!
    
    private var totalDistanceView: UIView!
    private var totalDistanceTitleLabel: UILabel!
    private var totalDistanceValueLabel: UILabel!
    
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
        
        if let firstOd = data.first?.odometer, let lastOd = data.last?.odometer {
            totalDistanceValueLabel.text = "\(firstOd - lastOd) км"
            
            if let first = data.first?.date, let last = data.last?.date {
                let diff = Calendar.current.dateComponents([.day], from: last, to: first)

                totalDaysValueLabel.text = "\(diff.day ?? 1) д"
                if let days = diff.day, days != 0 {
                    self.averageLabel.makeAttributedStringForAverageData(for: ["Средний пробег: ",
                                                                               " км/день"],
                                                                         and: "\((firstOd - lastOd) / (diff.day ?? 1))")
                } else {
                    self.averageLabel.makeAttributedStringForAverageData(for: ["Средний пробег: ",
                                                                               " км/день"],
                                                                         and: "\((firstOd - lastOd) / 1)")
                }
            }
        }
        
        cellView.snp.updateConstraints {
            $0.height.equalTo(contentView.frame.height)
        }
    }
}

extension MileageCell {
    private func makeUI() {
        backgroundColor = .clear
        
        titleLabel = UILabel()
        titleLabel.textColor = .darkGray
        titleLabel.text = "Пробег"
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
        
        totalDaysView = UIView()
        totalDaysView.setCornerRadius(15)
        totalDaysView.backgroundColor = .lightBlue
        totalsStackView.addArrangedSubview(totalDaysView)
        totalDaysView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        totalDaysTitleLabel = UILabel()
        totalDaysTitleLabel.text = "Всего дней:"
        totalDaysTitleLabel.setFontSize(size: 14)
        totalDaysView.addSubview(totalDaysTitleLabel)
        totalDaysTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
        }
        
        totalDaysValueLabel = UILabel()
        totalDaysValueLabel.textColor = .black
        totalDaysValueLabel.setFontSize(size: 15)
        totalDaysView.addSubview(totalDaysValueLabel)
        totalDaysValueLabel.snp.makeConstraints {
            $0.top.equalTo(totalDaysTitleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        totalDistanceView = UIView()
        totalDistanceView.setCornerRadius(15)
        totalDistanceView.backgroundColor = .lightBlue
        totalsStackView.addArrangedSubview(totalDistanceView)
        totalDistanceView.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        totalDistanceTitleLabel = UILabel()
        totalDistanceTitleLabel.text = "Общий пробег:"
        totalDistanceTitleLabel.setFontSize(size: 14)
        totalDistanceView.addSubview(totalDistanceTitleLabel)
        totalDistanceTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
        }
        
        totalDistanceValueLabel = UILabel()
        totalDistanceValueLabel.textColor = .black
        totalDistanceValueLabel.setFontSize(size: 15)
        totalDistanceView.addSubview(totalDistanceValueLabel)
        totalDistanceValueLabel.snp.makeConstraints {
            $0.top.equalTo(totalDistanceTitleLabel.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
}

extension MileageCell {
    static var cellSize: CGSize { CGSize(width: UIScreen.main.bounds.width - 32, height: 120) }
    
    static func cellSize(refueling: UserMileage) -> CGSize {
        if let price = refueling.refueling?.price, price.isZero {
            return CGSize(width: Device.deviceWidth - 32, height: 55)
        }
        return CGSize(width: Device.deviceWidth - 32, height: 60)
    }
}
