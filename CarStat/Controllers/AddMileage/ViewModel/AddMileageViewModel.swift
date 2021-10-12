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
    var newDate = BehaviorRelay<Date?>.init(value: nil)
    var newOdometer = BehaviorRelay<Int?>.init(value: nil)
    
    let disposeBag = DisposeBag()
    let sections = BehaviorRelay<[SectionModel]>.init(value: [])
    
    init(lastMileage: UserMileage?) {
        self.lastMileage.accept(lastMileage)
        
        subscribe()
        configureSections()
    }
    
    // MARK: - Functions
    private func subscribe() {
        newMileage
            .subscribe(onNext: { [weak self] data in
                guard self != nil, let data = data else { return }
                
                StorageManager.shared.save(mileage: data)
            })
            .disposed(by: disposeBag)
    }
    
    func configureSections() {
        var items: [ItemModel] = []
        
        items.append(.input)
        items.append(.date)
        items.append(.button)
        
        sections.accept([.mainSection(items: items)])
    }
}

// MARK: - Data source
extension AddMileageViewModel {
    enum SectionModel {
        case mainSection(items: [ItemModel])
    }
    
    enum ItemModel {
        case button
        case input
        case date
        
        var id: String {
            switch self {
            case .button:
                return "button"
            case .input:
                return "input"
            case .date:
                return "date"
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
