//
//  CSDateInputCell.swift
//  CarStat
//
//  Created by Aleksey Mironov on 20.09.2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CSDateInputCell: RxCollectionViewCell {
    // MARK: - UI
    var input: UIDatePicker!
    
    // MARK: - Lifecycle
    override func initialSetup() {
        super.initialSetup()
        
        makeUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func configure(text: String) {
        
    }
}

extension CSDateInputCell {
    private func makeUI() {
        backgroundColor = .clear
        
        // TITLE
        input = UIDatePicker()
        input.datePickerMode = .date
        contentView.addSubview(input)
        input.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

extension CSDateInputCell {
    static func cellSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32, height: 180)
    }
}
