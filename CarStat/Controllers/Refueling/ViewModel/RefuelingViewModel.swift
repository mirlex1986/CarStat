//
//  MainScreenViewModel.swift
//  CarStat
//
//  Created by Aleksey Mironov on 14.09.2021.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RxRealm

final class RefuelingViewModel {
    // MARK: - Properties
    let mileage = BehaviorRelay<[UserMileage]>.init(value: [])
    
    let disposeBag = DisposeBag()
    let sections = BehaviorRelay<[SectionModel]>.init(value: [])
    
    init() {
        
        fetchData()
        subscribe()
    }
    
    // MARK: - Functions
    private func subscribe() {
        mileage
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.configureSections()
            })
            .disposed(by: disposeBag)
    }
    
    func configureSections() {
        var items: [ItemModel] = []
        let mileage = mileage.value.sorted { $0.date > $1.date }

        let sorted = mileage.sorted { $0.odometer > $1.odometer }
        
        sorted.forEach { data in
            items.append(.refueling(mileage: data))
        }
        
        sections.accept([.mainSection(items: items)])
    }
}

// MARK: - Functions
extension RefuelingViewModel {
    func fetchData() {
        let mileage = StorageManager.shared.fetchData()
        
        Observable.collection(from: mileage)
            .subscribe(onNext: { [weak self] values in
                guard let self = self else { return }

                var someObjects: [UserMileage] = []
                for object in values{
                    someObjects.append(object)
                }
                
                self.mileage.accept(someObjects)
            })
            .disposed(by: disposeBag)
    }
    
    func calculateMileage() -> String {
        let mileages = mileage.value
        guard let first = mileages.first, let last = mileages.last else { return "" }
        
        let diffInDays = Calendar.current.dateComponents([.day], from: first.date, to: last.date).day
        var totalDaysDescription: String {
            let count = diffInDays ?? -1
            
            switch count {
            case 0: return "\(diffInDays ?? 0) дней"
            case 1: return "\(diffInDays ?? 0) день"
            case 2...4: return "\(diffInDays ?? 0) дня"
            case 5...: return "\(diffInDays ?? 0) дней"
                
            default: return "\(diffInDays ?? 0)"
            }
        }
        let diffMiles = last.odometer - first.odometer
        if let diffInDays = diffInDays, diffInDays > 0 {
            let day = Double(diffMiles) / Double(diffInDays)
            return "Пробег \(diffMiles) км за \(totalDaysDescription) \n Средний пробег за день: \(day)"
        }
        return "Пробег \(diffMiles) км за \(totalDaysDescription)"
    }
}


// MARK: - Data source
extension RefuelingViewModel {
    enum SectionModel {
        case mainSection(items: [ItemModel])
    }
    
    enum ItemModel {
        case button
        case text(text: String, alignment: NSTextAlignment)
        case chart(mileages: [UserMileage])
        case refueling(mileage: UserMileage)
        
        var id: String {
            switch self {
            case .button:
                return "button"
            case .text(let text, _):
                return "text \(text)"
            case .refueling(let mileage):
                return "refueling \(mileage.date) \(mileage.odometer)"
            case .chart(let mileages):
                return "mileage \(mileages)"
            }
        }
    }
}

extension RefuelingViewModel.SectionModel: AnimatableSectionModelType {
    typealias Item = RefuelingViewModel.ItemModel
    
    var identity: String {
        return "main_section"
    }
    
    var items: [RefuelingViewModel.ItemModel] {
        switch self {
        case .mainSection(let items):
            return items.map { $0 }
        }
    }
    
    init(original: RefuelingViewModel.SectionModel, items: [RefuelingViewModel.ItemModel]) {
        switch original {
        case .mainSection:
            self = .mainSection(items: items)
        }
    }
}

extension RefuelingViewModel.ItemModel: RxDataSources.IdentifiableType, Equatable {
    static func == (lhs: RefuelingViewModel.ItemModel, rhs: RefuelingViewModel.ItemModel) -> Bool {
        lhs.identity == rhs.identity
    }
    
    var identity: String {
        return id
    }
}
