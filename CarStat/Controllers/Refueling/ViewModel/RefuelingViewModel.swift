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
        var previos = 0
        
        for (i, mile) in mileage.value.enumerated() {
            if i < mileage.value.count - 1 {
                previos = mileage.value[i + 1].odometer
            }
            
            items.append(.refueling(mileage: mile, previos: previos))
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
                for object in values {
                    someObjects.append(object)
                }
                
                self.mileage.accept([])
                self.mileage.accept(someObjects)
            })
            .disposed(by: disposeBag)
    }
}


// MARK: - Data source
extension RefuelingViewModel {
    enum SectionModel {
        case mainSection(items: [ItemModel])
    }
    
    enum ItemModel {
        case refueling(mileage: UserMileage, previos: Int = 0)
        
        var id: String {
            switch self {
            case .refueling(let mileage, let previos):
                return "refueling \(mileage) \(previos)"
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
