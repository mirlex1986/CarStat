//
//  CSInputCell.swift
//  CarStat
//
//  Created by Aleksey Mironov on 20.09.2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum InputType {
    case odometer
    case fuelPrice
    case fuelCount
    case fuelTotalPrice
}

final class CSInputCell: RxCollectionViewCell {
    // MARK: - UI
    var label: UILabel!
    var input: UITextField!
    
    // MARK: - Lifecycle
    override func initialSetup() {
        super.initialSetup()
        
        makeUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func configure(text: String, inputType: InputType) {
        input.text = text
        
        switch inputType {
        case .odometer:
            input.keyboardType = .numberPad
        case .fuelPrice:
            input.keyboardType = .decimalPad
        case .fuelCount:
            input.keyboardType = .decimalPad
        case .fuelTotalPrice:
            input.keyboardType = .decimalPad
        }
    }
}

extension CSInputCell {
    private func makeUI() {
        backgroundColor = .clear
        
        label = UILabel()
//        label.textColor = .clear
        label.text = "text"
        label.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        input = UITextField()
        input.borderStyle = .none
        input.placeholder = ""
        contentView.addSubview(input)
        input.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).inset(4)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
    }
}

extension CSInputCell {
    static func cellSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 32, height: 50)
    }
}

extension CSInputCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        label.textColor = .black
        label.text = "text"
        return false
    }
}
