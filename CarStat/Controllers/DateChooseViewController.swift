

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class DateChooseViewController: CSPopUpViewController {
    // MARK: - UI
    private var doneButton: UIButton!
    private var datePicker: UIDatePicker!
    
    // MARK: - Properties
    let date = BehaviorRelay<Date?>.init(value: nil)
    let resultDate = BehaviorRelay<Date?>.init(value: nil)

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        subscribe()
    }
    
    // MARK: - Functions
    private func subscribe() {
        date
            .subscribe(onNext: { [weak self] date in
                guard let self = self else { return }

                self.datePicker.setDate(date ?? Date(), animated: false)
            })
            .disposed(by: disposeBag)

        doneButton.rx.tap
            .subscribe(onNext: { [weak self] date in
                guard let self = self else { return }

                self.resultDate.accept(self.datePicker.date)
                self.dismissWithAnimaion()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Picker controller
extension DateChooseViewController: PickerController {
    var result: Observable<PickerResult?> {
        self.resultDate.compactMap { $0 }.asObservable()
    }
}

extension DateChooseViewController {
    override func makeUI() {
        super.makeUI()
        
        // CLOSE BUTTON
        configureCloseButton(isHidden: true)
        
        // DONE BUTTON
        doneButton = UIButton()
        doneButton.titleLabel?.setFontSize(size: 17)
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.setTitle("Готово", for: .normal)
        contentView.addSubview(doneButton)
        doneButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.bottom.equalTo(separator)
            $0.right.equalToSuperview().inset(16)
            $0.height.equalTo(32)
        }
        
        // DATEPICKER
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.locale = Locale(identifier: "ru_RU")
        if #available(iOS 13.4, *) { datePicker.preferredDatePickerStyle = .wheels }
        contentView.addSubview(datePicker)
        datePicker.snp.makeConstraints {
            $0.top.equalTo(doneButton.snp.bottom)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(48)
        }
    }
}

