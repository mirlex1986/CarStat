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
    case dateDisabled
}

final class CSInputCell: RxCollectionViewCell {
    // MARK: - UI
    var descriptionLabel: UILabel!
    var inputTextField: UITextField!
    
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
            descriptionLabel.textColor = .black
            inputTextField.text = text
        }
        
            switch inputType {
            case .odometer:
                descriptionLabel.text = "Одометр"
                
                inputTextField.placeholder = "Одометр"
                inputTextField.keyboardType = .numberPad
                
            case .fuelPrice:
                descriptionLabel.text = "Цена"
                
                inputTextField.placeholder = "Цена"
                inputTextField.keyboardType = .decimalPad
                
            case .fuelCount:
                descriptionLabel.text = "Количество"
                
                inputTextField.placeholder = "Количество"
                inputTextField.keyboardType = .decimalPad
                
            case .fuelTotalPrice:
                descriptionLabel.text = "Итоговая стоимость"
                
                inputTextField.placeholder = "Итоговая стоимость"
                inputTextField.keyboardType = .decimalPad
                
            case .totalSummLitersDisabled:
                descriptionLabel.text = "Топлива залито:"
                
                inputTextField.text = text
                inputTextField.isEnabled = false
                
            case .dateDisabled:
                descriptionLabel.text = "Дата"
                descriptionLabel.textColor = .black
                
                inputTextField.text = text
                inputTextField.backgroundColor = .white
                inputTextField.isEnabled = false
            }
    }
    
    private func subscribe() {
        
    }
}

extension CSInputCell {
    private func makeUI() {
        backgroundColor = .clear
        
        descriptionLabel = UILabel()
        descriptionLabel.textColor = .clear
        descriptionLabel.setFontSize(size: 12)
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        inputTextField = UITextField()
        inputTextField.borderStyle = .roundedRect
        inputTextField.delegate = self
        contentView.addSubview(inputTextField)
        inputTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(4)
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
        descriptionLabel.textColor = .black
        return true
    }
}
