import RxSwift
import RxCocoa
import RxDataSources
import RxRealm

final class ServicesViewModel {
    // MARK: - Properties
    let mileage = BehaviorRelay<[UserMileage]>.init(value: [])
    
    let disposeBag = DisposeBag()
    let sections = BehaviorRelay<[SectionModel]>.init(value: [])
    
    let rotateMainLoader = PublishRelay<Bool>()
    
    init() {
        
        subscribe()
    }
    
    // MARK: - Functions
    private func subscribe() {
        mileage
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                
            })
            .disposed(by: disposeBag)
    }
    
    func configureSections() {
        var items: [ItemModel] = []
        
        items.append(.empty(height: Device.deviceHeight / 3, index: items.count))
        items.append(.text(text: "Раздел не готов =(", alignment: .center))
        
        sections.accept([.mainSection(items: items)])
    }
    
    func configureLoader() {
        self.rotateMainLoader.accept(true)
//        sections.accept([SectionModel.mainSection(items: [ItemModel.empty(height: 2400, index: 0)])])
    }
}

// MARK: - Functions
extension ServicesViewModel {
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
extension ServicesViewModel {
    enum SectionModel {
        case mainSection(items: [ItemModel])
    }
    
    enum ItemModel {
        case empty(height: CGFloat, index: Int)
        case text(text: String, alignment: NSTextAlignment)
        
        var id: String {
            switch self {
            case .empty(let height, let index):
                return "empty \(height) \(index)"
            case .text(let text):
                return "text \(text)"
            }
        }
    }
}

extension ServicesViewModel.SectionModel: AnimatableSectionModelType {
    typealias Item = ServicesViewModel.ItemModel
    
    var identity: String {
        return "main_section"
    }
    
    var items: [ServicesViewModel.ItemModel] {
        switch self {
        case .mainSection(let items):
            return items.map { $0 }
        }
    }
    
    init(original: ServicesViewModel.SectionModel, items: [ServicesViewModel.ItemModel]) {
        switch original {
        case .mainSection:
            self = .mainSection(items: items)
        }
    }
}

extension ServicesViewModel.ItemModel: RxDataSources.IdentifiableType, Equatable {
    static func == (lhs: ServicesViewModel.ItemModel, rhs: ServicesViewModel.ItemModel) -> Bool {
        lhs.identity == rhs.identity
    }
    
    var identity: String {
        return id
    }
}
