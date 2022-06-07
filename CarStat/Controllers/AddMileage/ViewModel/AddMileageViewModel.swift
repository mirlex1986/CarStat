import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RxRealm
import RealmSwift

final class AddMileageViewModel {
    // MARK: - Properties
    var lastMileage = BehaviorRelay<UserMileage?>.init(value: nil)
    var isEditing = BehaviorRelay<Bool>(value: false)
    
    var newMileage = PublishRelay<UserMileage?>()
    var newDate = BehaviorRelay<String?>.init(value: nil)
    var newOdometer = BehaviorRelay<Int?>.init(value: nil)
    var newFuelPrice = BehaviorRelay<Double?>.init(value: nil)
    var newLiters = BehaviorRelay<Double?>.init(value: nil)
    var newTotaalPrice = BehaviorRelay<Double?>.init(value: nil)
    
    let disposeBag = DisposeBag()
    let sections = BehaviorRelay<[SectionModel]>.init(value: [])
    
    init(lastMileage: UserMileage?, isEditing: Bool = false) {
        self.lastMileage.accept(lastMileage)
        self.isEditing.accept(isEditing)
        
        subscribe()
        configureSections()
    }
    
    // MARK: - Functions
    private func subscribe() {
        newMileage
            .subscribe(onNext: { [weak self] data in
                guard let self = self, let data = data else { return }
                
                if self.isEditing.value {
                    StorageManager.shared.update(mileage: data)
                } else {
                    StorageManager.shared.save(mileage: data)
                }
            })
            .disposed(by: disposeBag)
        
        lastMileage
            .subscribe(onNext: { [weak self] value in
                guard let self = self, let value = value else { return }
                
                switch self.isEditing.value {
                case true:
                    self.newDate.accept(value.date)
                    self.newOdometer.accept(value.odometer)
                    self.newFuelPrice.accept(value.refueling?.price)
                    self.newLiters.accept(value.refueling?.quantity)
                    self.newTotaalPrice.accept(value.refueling?.totalPrice)
                case false:
                    self.newDate.accept(Formatters.dateApi.string(from: Date()))
                }
            })
            .disposed(by: disposeBag)
    }
    
    func configureSections() {
        var items: [ItemModel] = []
        
        items.append(.input(text: self.newOdometer.value == nil ? nil : "\(self.newOdometer.value ?? 0)", type: .odometer))
        items.append(.date(date: Formatters.dateApi.date(from: self.newDate.value ?? "") ?? Date()))
        items.append(.input(text: self.newFuelPrice.value == nil ? nil : "\(self.newFuelPrice.value ?? 0)", type: .fuelPrice))
        items.append(.input(text: self.newLiters.value == nil ? nil : "\(self.newLiters.value ?? 0)", type: .fuelCount))
        items.append(.input(text: self.newTotaalPrice.value == nil ? nil : "\(self.newTotaalPrice.value ?? 0)", type: .fuelTotalPrice))
        items.append(.button(type: .add))
        
        if self.isEditing.value {
            items.append(.button(type: .delete))
        }
        
        sections.accept([.mainSection(items: items)])
    }
}

extension AddMileageViewModel {
    enum ButtonType {
        case add
        case delete
    }
}

// MARK: - Data source
extension AddMileageViewModel {
    enum SectionModel {
        case mainSection(items: [ItemModel])
    }
    
    enum ItemModel {
        case button(type: ButtonType)
        case input(text: String?, type: InputType)
        case label(text: String)
        case date(date: Date)
        
        var id: String {
            switch self {
            case .button(let type):
                return "button \(type)"
            case .input(let text, let type):
                return "input \(String(describing: text)) \(type)"
            case .label(let text):
                return "label \(text)"
            case .date(let date):
                return "date \(date)"
            }
        }
    }
}

extension AddMileageViewModel.SectionModel: AnimatableSectionModelType {
    typealias Item = AddMileageViewModel.ItemModel
    
    var identity: String {
        return "main_section"
    }
    
    var items: [AddMileageViewModel.ItemModel] {
        switch self {
        case .mainSection(let items):
            return items.map { $0 }
        }
    }
    
    init(original: AddMileageViewModel.SectionModel, items: [AddMileageViewModel.ItemModel]) {
        switch original {
        case .mainSection:
            self = .mainSection(items: items)
        }
    }
}

extension AddMileageViewModel.ItemModel: RxDataSources.IdentifiableType, Equatable {
    static func == (lhs: AddMileageViewModel.ItemModel, rhs: AddMileageViewModel.ItemModel) -> Bool {
        lhs.identity == rhs.identity
    }
    
    var identity: String {
        return id
    }
}

extension AddMileageViewModel {
    func newRecordData() {
        guard let newDate = self.newDate.value,
              let newOdodmeter = self.newOdometer.value else { return }
        
        let newValue = UserMileage()
        if !self.isEditing.value {
            newValue.primaryKey = UUID().uuidString
        } else {
            newValue.primaryKey = self.lastMileage.value?.primaryKey ?? ""
        }
        newValue.date = newDate
        newValue.odometer = newOdodmeter
        let newRef = LocalRefueling()
        newRef.price = self.newFuelPrice.value ?? 0.0
        newRef.quantity = self.newLiters.value ?? 0.0
        newRef.totalPrice = self.newTotaalPrice.value ?? 0.0
        newValue.type = newRef.totalPrice > 0 ? RecordType.refueling.rawValue : RecordType.mileage.rawValue
        newValue.refueling = newRef
        
        self.newMileage.accept(newValue)
    }
}
