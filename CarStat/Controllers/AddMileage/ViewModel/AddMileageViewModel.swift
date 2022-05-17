//
//  AddMileageViewModel.swift
//  CarStat
//
//  Created by Aleksey Mironov on 20.09.2021.
//


import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RxRealm
import RealmSwift

final class AddMileageViewModel {
    // MARK: - Properties
    var lastMileage = BehaviorRelay<UserMileage?>.init(value: nil)
    var newMileage = PublishRelay<UserMileage?>()
    var newDate = BehaviorRelay<String?>.init(value: nil)
    var newOdometer = BehaviorRelay<Int?>.init(value: nil)
    var newFuelPrice = BehaviorRelay<Double?>.init(value: nil)
    var newLiters = BehaviorRelay<Double?>.init(value: nil)
    var newTotaalPrice = BehaviorRelay<Double?>.init(value: nil)
    
    let disposeBag = DisposeBag()
    let sections = BehaviorRelay<[SectionModel]>.init(value: [])
    
    init(lastMileage: UserMileage?) {
        self.lastMileage.accept(lastMileage)
        
        subscribe()
        configureSections()
    }
    
    init() {        
        subscribe()
        configureSections()
    }
    
    // MARK: - Functions
    private func subscribe() {
        newMileage
            .subscribe(onNext: { [weak self] data in
                guard let self = self, let data = data else { return }
                
                if self.lastMileage.value == nil {
                    StorageManager.shared.save(mileage: data)
                } else {
                    StorageManager.shared.update(mileage: data)
                }

            })
            .disposed(by: disposeBag)
        
        lastMileage
            .subscribe(onNext: { [weak self] value in
                guard let self = self, let value = value else { return }
                
                self.newOdometer.accept(value.odometer)
                self.newDate.accept(value.date)
                self.newFuelPrice.accept(value.refueling?.price)
                self.newLiters.accept(value.refueling?.quantity)
                self.newTotaalPrice.accept(value.refueling?.totalPrice)
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
        items.append(.button)
        
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
        case button
        case input(text: String?, type: InputType)
        case label(text: String)
        case date(date: Date)
        
        var id: String {
            switch self {
            case .button:
                return "button"
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
