//
//  CSDateSwitcher.swift
//  CarStat
//
//  Created by Aleksey Mironov on 24.05.2022.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CSDateSwitcher: UIView {
    // MARK: - UI
    private var mainView: UIView!
    private var leftButton: UIButton!
    private var dateLabel: UILabel!
    private var rightButton: UIButton!
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    let leftButtonTapped = PublishRelay<Bool>()
    let rightButtonTapped = PublishRelay<Bool>()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
        subscribe()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        makeUI()
        subscribe()
    }
    
    func configure(text: String) {
        dateLabel.text = text
        
    }
    
    private func subscribe() {
        leftButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                print("--- left tapped")
                leftButtonTapped.accept(true)
            })
            .disposed(by: disposeBag)
        
        rightButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                print("--- right tapped")
                rightButtonTapped.accept(true)
            })
            .disposed(by: disposeBag)
    }
}

extension CSDateSwitcher {
    private func makeUI() {
        
        mainView = UIView()
        mainView.backgroundColor = .lightBlue
        addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        leftButton = UIButton()
        leftButton.setImage(Images.backButton, for: .normal)
        mainView.addSubview(leftButton)
        leftButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
        }
        
        rightButton = UIButton()
        rightButton.setImage(Images.backButton, for: .normal)
        rightButton.transform = CGAffineTransform(rotationAngle: .pi)
        mainView.addSubview(rightButton)
        rightButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(30)
        }
        
        dateLabel = UILabel()
        dateLabel.textAlignment = .center
        mainView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

