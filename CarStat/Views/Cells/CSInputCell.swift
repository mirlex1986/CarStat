import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum InputType {
    case odometer
    case fuelPrice
    case fuelCount
    case fuelTotalPrice
    case totalSummLitersDisabled
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
    
    func configure(text: String?, inputType: InputType) {
        if let text = text, let number = Double(text), !number.isZero {
            label.textColor = .black
            input.text = text
        }
        
            switch inputType {
            case .odometer:
                label.text = "Одометр"
                input.placeholder = "Одометр"
                input.keyboardType = .numberPad
            case .fuelPrice:
                label.text = "Цена"
                input.placeholder = "Цена"
                input.keyboardType = .decimalPad
            case .fuelCount:
                label.text = "Количество"
                input.placeholder = "Количество"
                input.keyboardType = .decimalPad
            case .fuelTotalPrice:
                label.text = "Итоговая стоимость"
                input.placeholder = "Итоговая стоимость"
                input.keyboardType = .decimalPad
            case .totalSummLitersDisabled:
                label.text = "Топлива залито:"
                input.text = text
                input.isEnabled = false
            }
    }
}

extension CSInputCell {
    private func makeUI() {
        backgroundColor = .clear
        
        label = UILabel()
        label.textColor = .clear
        label.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        input = UITextField()
        input.borderStyle = .roundedRect
        input.delegate = self
        contentView.addSubview(input)
        input.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(4)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
    }
}

extension CSInputCell {
    static func cellSize() -> CGSize {
        return CGSize(width: Device.deviceWidth - 32, height: 50)
    }
}

extension CSInputCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        label.textColor = .black
        return true
    }
}
