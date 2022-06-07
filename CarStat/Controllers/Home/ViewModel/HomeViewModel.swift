import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import RxRealm

final class HomeViewModel {
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
        
        if mileage.value.isEmpty {
            items.append(.empty(height: Device.deviceHeight / 2 - 100, index: items.count))
            items.append(.text(text: "Нет данных о тратах"))
            
        } else {
            items.append(.refueling(mileage: mileage.value))
            items.append(.empty(height: 40, index: items.count))
            items.append(.mileage(mileage: mileage.value))
        }
        
        sections.accept([.mainSection(items: items)])
    }
}

// MARK: - Functions
extension HomeViewModel {
    func fetchData() {
        let mileage = StorageManager.shared.fetchData()
        
        Observable.collection(from: mileage)
            .subscribe(onNext: { [weak self] values in
                guard let self = self else { return }

                var someObjects: [UserMileage] = []
                for object in values {
                    someObjects.append(object)
                }
                
                self.mileage.accept(someObjects)
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - Data source
extension HomeViewModel {
    enum SectionModel {
        case mainSection(items: [ItemModel])
    }
    
    enum ItemModel {
        case empty(height: CGFloat, index: Int)
        case button
        case text(text: String, alignment: NSTextAlignment = .center)
        case refueling(mileage: [UserMileage])
        case mileage(mileage: [UserMileage])
        
        var id: String {
            switch self {
            case .empty(_, let index):
                return "separator \(index)"
            case .button:
                return "button"
            case .text(let text, _):
                return "text \(text)"
            case .refueling(let mileage):
                return "refueling \(mileage.count)"
            case .mileage(let mileage):
                return "mileage \(mileage.count)"
            }
        }
    }
}

extension HomeViewModel.SectionModel: AnimatableSectionModelType {
    typealias Item = HomeViewModel.ItemModel
    
    var identity: String {
        return "main_section"
    }
    
    var items: [HomeViewModel.ItemModel] {
        switch self {
        case .mainSection(let items):
            return items.map { $0 }
        }
    }
    
    init(original: HomeViewModel.SectionModel, items: [HomeViewModel.ItemModel]) {
        switch original {
        case .mainSection:
            self = .mainSection(items: items)
        }
    }
}

extension HomeViewModel.ItemModel: RxDataSources.IdentifiableType, Equatable {
    static func == (lhs: HomeViewModel.ItemModel, rhs: HomeViewModel.ItemModel) -> Bool {
        lhs.identity == rhs.identity
    }
    
    var identity: String {
        return id
    }
}
