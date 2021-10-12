//
//  AddMileageViewController.swift
//  CarStat
//
//  Created by Aleksey Mironov on 20.09.2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class AddMileageViewController: UIViewController {
    // MARK: - UI
    private var navBar: UINavigationBar!
    private var collectionView: UICollectionView!
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
    }
    
    private func generateDataSource() -> RxCollectionViewSectionedAnimatedDataSource<Section> {
        return RxCollectionViewSectionedAnimatedDataSource<Section>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .fade,
                                                           reloadAnimation: .fade,
                                                           deleteAnimation: .fade),
            configureCell: { dataSource, collectionView, indexPath, _ in
                let item: Item = dataSource[indexPath]
                switch item {
                case .button:
                    return self.buttonCell(indexPath: indexPath)
                case .input:
                    return self.inputCell(indexPath: indexPath)
                case .date:
                    return self.calendarCell(indexPath: indexPath)
                }
            },
            configureSupplementaryView: { _, _, _, _ in
                return UICollectionReusableView()
            })
    }
    // MARK: - Cells
    private func buttonCell(indexPath: IndexPath) -> CSCollectionViewCell {
        let cell: CSButtonCell = collectionView.cell(indexPath: indexPath)
        cell.configure(text: "Добавить")
        
        cell.button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let newDate = self.viewModel.newDate.value, let newOdodmeter = self.viewModel.newOdometer.value else { return }
                
                let newValue = UserMileage()
                newValue.date = newDate
                newValue.odometer = newOdodmeter
                
                self.viewModel.newMileage.accept(newValue)
                
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
    
    private func inputCell(indexPath: IndexPath) -> CSCollectionViewCell {
        let cell: CSInputCell = collectionView.cell(indexPath: indexPath)
        
        cell.input.keyboardType = .numberPad
        
        if let message = self.viewModel.lastMileage.value {
            cell.configure(text: "\(message.odometer)")
        }
        
        cell.input.rx.text.changed
            .subscribe(onNext: { [weak self] value in
                guard let self = self, let value = value, let newValue = Int(value) else { return }
                
                self.viewModel.newOdometer.accept(newValue)
            })
        
        return cell
    }
    
    private func calendarCell(indexPath: IndexPath) -> CSCollectionViewCell {
        let cell: CSDateInputCell = collectionView.cell(indexPath: indexPath)
        
        cell.input.rx.date.changed
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                
                self.viewModel.newDate.accept(value)
            })
        
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
        case .button:
            return CSButtonCell.cellSize
        case .input:
            return CSInputCell.cellSize()
        case .date:
            return CSDateInputCell.cellSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
}

extension AddMileageViewController {
    func makeUI() {
        view.backgroundColor = .white
        
        // NAVBAR
        navBar = UINavigationBar()
        navBar.setItems([UINavigationItem(title: "Add")], animated: true)
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
    
    private func makeCollectionView() -> UICollectionView {
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
