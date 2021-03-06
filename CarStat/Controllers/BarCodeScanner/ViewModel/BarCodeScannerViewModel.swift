import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class BarCodeScannerViewModel {
    // MARK: - Properties
    let disposeBag = DisposeBag()
    
    let metadata = BehaviorRelay<String?>.init(value: nil)
    let isParsingFinished = PublishRelay<Bool>()
    
    let refueling = BehaviorRelay<UserMileage?>(value: nil)
    let refuelingDate = BehaviorRelay<String>(value: "")
    let refuelingTotalPrice = BehaviorRelay<Double>(value: 0.0)
    
    let result = BehaviorRelay<UserMileage?>(value: nil)
    
    init() {
        
        subscribe()
    }
    
    // MARK: - Functions
    private func subscribe() {
        metadata
            .subscribe(onNext: { [weak self] data in
                guard let self = self, let data = data else { return }
                
                self.parseQR(data)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Methods
extension BarCodeScannerViewModel {
    private func parseQR(_ scannedString: String) {
        if let parsedDate = scannedString.components(separatedBy: "t=").last?.components(separatedBy: "&").first {
            let cutted = String(parsedDate.dropLast(5))
            if let date = Formatters.qrDate.date(from: cutted) {
                let dateStr = Formatters.dateLongOutput.string(from: date)
                self.refuelingDate.accept(dateStr)
            }
        }
        
        if let parsedDate = scannedString.components(separatedBy: "s=").last?.components(separatedBy: "&").first {
            if let date = Double(parsedDate) {
                self.refuelingTotalPrice.accept(date)
            }
        }

        self.isParsingFinished.accept(true)
    }
    
    func makeStringFromParsedData() -> String {
        var string = ""
        if !refuelingDate.value.isEmpty {
            string.append("\n Дата: \(refuelingDate.value)")
        }
        if !refuelingTotalPrice.value.isZero {
            string.append("\n Сумма: \(refuelingTotalPrice.value)")
        }
        
        return string
    }
    
    func generateResult() {
        let newValue = UserMileage()

        newValue.date = Formatters.dateLongOutput.date(from: self.refuelingDate.value) ?? Date()
//        newValue.odometer = 0
        let newRef = LocalRefueling()
//        newRef.price = self.newFuelPrice.value ?? 0.0
//        newRef.quantity = self.newLiters.value ?? 0.0
        newRef.totalPrice = self.refuelingTotalPrice.value
        newValue.type = RecordType.refueling.rawValue
        newValue.refueling = newRef
        
        self.result.accept(newValue)
        
        print("-----?", newValue.data)
    }
}
