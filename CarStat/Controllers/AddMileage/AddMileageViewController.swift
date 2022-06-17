import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import RealmSwift

class AddMileageViewController: CSViewController {
    // MARK: - UI
    private var navBar: CSNavigationBar!
    private var collectionView: CSCollectionView!
    private var label: UILabel!
    
    // MARK: - Properties
    typealias Item = AddMileageViewModel.ItemModel
    typealias Section = AddMileageViewModel.SectionModel
    
    var viewModel: AddMileageViewModel!
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
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                let item: Item = self.dataSource[indexPath]
                switch item {
                case .input(_, let type):
                    switch type {
                    case .dateDisabled:
                        self.openDatePicker(with: self.viewModel.newDate.value)
                        
                    default: break
                    }
                default: break
                }
            })
            .disposed(by: viewModel.disposeBag)
        
        navBar.leftButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: viewModel.disposeBag)
        
        navBar.rightButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                Router.barCodeScanner
                    .presentWithResult(from: self)
                    .subscribe(onNext: { [weak self] result in
                        guard let self = self, let result = result as? UserMileage else { return }
                        
                        print("-----", result)
                    })
                    .disposed(by: self.viewModel.disposeBag)
                
            })
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
                case .button(let type):
                    return self.buttonCell(indexPath: indexPath, type: type)
                case .input(let text, let type):
                    return self.inputCell(indexPath: indexPath, text: text, type: type)
                case .label(let text):
                    return self.labelCell(indexPath: indexPath, text: text)
                }
            },
            configureSupplementaryView: { _, _, _, _ in
                return UICollectionReusableView()
            })
    }
    // MARK: - Cells
    private func buttonCell(indexPath: IndexPath, type: AddMileageViewModel.ButtonType) -> CSCollectionViewCell {
        let cell: CSButtonCell = collectionView.cell(indexPath: indexPath)
        switch type {
        case.add:
            cell.configure(text: !self.viewModel.isEditing.value ? "Добавить" : "Изменить")
        case .delete:
            cell.configure(text: "Удалить")
        }
        
        cell.button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                switch type {
                case .add:
                    self.viewModel.newRecordData()
                    
                case .delete:
                    guard let last = self.viewModel.lastMileage.value else { return }
                    StorageManager.shared.delete(mileage: last)
                }

                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
    
    private func labelCell(indexPath: IndexPath, text: String) -> CSCollectionViewCell {
        let cell: CSTextCell = collectionView.cell(indexPath: indexPath)
        cell.configure(text: text)
       
        return cell
    }
    
    private func inputCell(indexPath: IndexPath, text: String?, type: InputType) -> CSCollectionViewCell {
        let cell: CSInputCell = collectionView.cell(indexPath: indexPath)
        cell.configure(text: text, inputType: type)
        
        cell.inputTextField.rx.text.changed
            .subscribe(onNext: { [weak self] value in
                guard let self = self, let value = value else { return }
                
                switch type {
                case .odometer:
                    self.viewModel.newOdometer.accept(Int(value))
                case .fuelPrice:
                    self.viewModel.newFuelPrice.accept(Double(value.replacingOccurrences(of: ",", with: ".")))
                case .fuelCount:
                    self.viewModel.newLiters.accept(Double(value.replacingOccurrences(of: ",", with: ".")))
                    if let price = self.viewModel.newFuelPrice.value, let liters = self.viewModel.newLiters.value {
                        
                        let total = round(liters * price * 100) / 100.0
                        self.viewModel.newTotaalPrice.accept(total)
                    }
                case .fuelTotalPrice:
                    if let doubleValue = Double(value.replacingOccurrences(of: ",", with: ".")) {
                        self.viewModel.newTotaalPrice.accept(doubleValue)
                    }
                default: break
                }
            
            })
            .disposed(by: cell.disposeBag)
        
        switch type {
        case .fuelTotalPrice:
            self.viewModel.newTotaalPrice
                .subscribe(onNext: {
                    guard let data = $0 else { return }
                    
                    cell.configure(text: "\(data)", inputType: type)
                })
                .disposed(by: viewModel.disposeBag)
        default: break
        }
        
        return cell
    }
    
    private func calendarCell(indexPath: IndexPath, date: Date) -> CSCollectionViewCell {
        let cell: CSDateInputCell = collectionView.cell(indexPath: indexPath)
        cell.configure(date: date)
        
        cell.input.rx.date
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                
                self.viewModel.newDate.accept(value.onlyDate)
                self.dismiss(animated: false)
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AddMileageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = dataSource[indexPath]
        switch item {
        case .empty(let height, _):
            return CSEmptyCell.cellSize(height: height)
        case .button:
            return CSButtonCell.cellSize
        case .input:
            return CSInputCell.cellSize()
        case .label(let text):
            return CSTextCell.cellSize(text: text)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
}

extension AddMileageViewController {
    override func makeUI() {
        view.backgroundColor = .white
        
        // NAVBAR
        navBar = CSNavigationBar()
        navBar.configure(title: "Добавить", [.rightButton, .backButton])
        navBar.configureRightButton(image: UIImage(systemName: "camera.circle") ?? UIImage())
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        
        // COLLECTION VIEW
        collectionView = makeCollectionView()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
    }
    
    private func makeCollectionView() -> CSCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let collectionView = CSCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }
}

extension AddMileageViewController {
    private func openDatePicker(with date: Date?) {

        Router.datePicker(date: date)
            .presentWithResult(from: self)
            .subscribe(onNext: { [weak self] result in
                guard let self = self, let date = result as? Date else { return }
                
                self.viewModel.newDate.accept(date)
                self.viewModel.configureSections()
            })
            .disposed(by: self.viewModel.disposeBag)
    }
}
