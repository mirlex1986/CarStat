import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewController: CSViewController {
    // MARK: - UI
    private var navBar: CSNavigationBar!
    private var collectionView: CSCollectionView!
    
    // MARK: - Properties
    typealias Item = HomeViewModel.ItemModel
    typealias Section = HomeViewModel.SectionModel
    
    var viewModel = HomeViewModel()
    var dataSource: RxCollectionViewSectionedAnimatedDataSource<Section>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        prepare()
        subscribe()
    }
    
    // MARK: - Functions
    private func prepare() {
        dataSource = generateDataSource()
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: viewModel.disposeBag)
    }
    
    private func subscribe() {
        viewModel.sections.asObservable()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: viewModel.disposeBag)
    }
    
    private func generateDataSource() -> RxCollectionViewSectionedAnimatedDataSource<Section> {
        return RxCollectionViewSectionedAnimatedDataSource<Section>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .fade,
                                                           reloadAnimation: .fade,
                                                           deleteAnimation: .fade),
            configureCell: { dataSource, collectionView, indexPath, _ in
                let item: Item = dataSource[indexPath]
                switch item {
                case .empty:
                    return self.emptyCell(self.collectionView, indexPath: indexPath)
                case .button:
                    return self.buttonCell(indexPath: indexPath)
                case .text(let text, let alignment):
                    return self.textCell(self.collectionView, indexPath: indexPath, text: text, alignment: alignment)
                case .refueling(let mileage):
                    return self.refuelingCell(indexPath: indexPath, refueling: mileage)
                case .mileage(let mileage):
                    return self.mileageCell(indexPath: indexPath, refueling: mileage)
                }
            },
            configureSupplementaryView: { _, _, _, _ in
                return UICollectionReusableView()
            })
    }
    // MARK: - Cells
    private func buttonCell(indexPath: IndexPath) -> CSCollectionViewCell {
        let cell: CSButtonCell = collectionView.cell(indexPath: indexPath)
        cell.configure(text: "Добавить показания одометра")
        
        cell.button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let vc = AddMileageViewController()
                if let last = self.viewModel.mileage.value.last {
                    vc.viewModel = AddMileageViewModel(lastMileage: last)
                } else {
                    let new = UserMileage()
                    new.date = Date().onlyDate ?? Date()
                    new.odometer = 0
                    vc.viewModel = AddMileageViewModel(lastMileage: new)
                }

                self.present(vc, animated: true, completion: nil)
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
    
    private func refuelingCell(indexPath: IndexPath, refueling: [UserMileage]) -> CSCollectionViewCell {
        let cell: RefuelingCell = collectionView.cell(indexPath: indexPath)
        cell.configure(with: refueling)
        
        return cell
    }
    
    private func mileageCell(indexPath: IndexPath, refueling: [UserMileage]) -> CSCollectionViewCell {
        let cell: MileageCell = collectionView.cell(indexPath: indexPath)
        cell.configure(with: refueling)
        
        return cell
    }
    
    private func chartCell(indexPath: IndexPath, mileages: [UserMileage]) -> CSCollectionViewCell {
        let cell: CSChartCell = collectionView.cell(indexPath: indexPath)
        cell.configure(mileages: mileages)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = dataSource[indexPath]
        switch item {
        case .empty(let height, _):
            return CSEmptyCell.cellSize(height: height)
        case .button:
            return CSButtonCell.cellSize
        case .text(let text, _):
            return CSTextCell.cellSize(text: text)
        case .refueling:
            return RefuelingCell.cellSize
        case .mileage:
            return MileageCell.cellSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
}

extension HomeViewController {
    override func makeUI() {
        super.makeUI()
        view.backgroundColor = .white
        
        // NAVBAR
        navBar = CSNavigationBar()
        navBar.configure(title: "Общая статистика")
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        
        // COLLECTION VIEW
        collectionView = makeCollectionView()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
    }
    
    private func makeCollectionView() -> CSCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        
        let collectionView = CSCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }
}
