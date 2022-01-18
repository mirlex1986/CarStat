//
//  MainScreenViewController.swift
//  CarStat
//
//  Created by Aleksey Mironov on 13.09.2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class MainScreenViewController: UIViewController {
    // MARK: - UI
    private var navBar: UINavigationBar!
    private var collectionView: UICollectionView!
    private var label: UILabel!
    private var button: UIButton!
    
    // MARK: - Properties
    typealias Item = MainScreenViewModel.ItemModel
    typealias Section = MainScreenViewModel.SectionModel
    
    var viewModel = MainScreenViewModel()
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
        
        viewModel.mileage
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.label.text = self.viewModel.calculateMileage()
            })
            .disposed(by: viewModel.disposeBag)
        
        button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.addMileage()
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
                case .button:
                    return self.buttonCell(indexPath: indexPath)
                case .text(let text, let alignment):
                    return self.textCell(indexPath: indexPath, text: text, alignment: alignment)
                case .refueling(let mileage):
                    return self.refuelingCell(indexPath: indexPath, mileage: mileage)
                case .chart(let mileages):
                    return self.chartCell(indexPath: indexPath, mileages: mileages)
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
                    new.date = Date()
                    new.odometer = 0
                    vc.viewModel = AddMileageViewModel(lastMileage: new)
                }

                self.present(vc, animated: true, completion: nil)
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
    
    private func chartCell(indexPath: IndexPath, mileages: [UserMileage]) -> CSCollectionViewCell {
        let cell: CSChartCell = collectionView.cell(indexPath: indexPath)
        cell.configure(mileages: mileages)
        
        return cell
    }
    
    private func textCell(indexPath: IndexPath, text: String, alignment: NSTextAlignment) -> CSCollectionViewCell {
        let cell: CSTextCell = collectionView.cell(indexPath: indexPath)
        cell.configure(text: text, textAlignment: alignment)
        
        return cell
    }
    
    private func refuelingCell(indexPath: IndexPath, mileage: UserMileage) -> CSCollectionViewCell {
        let cell: RefuelingInfoCell = collectionView.cell(indexPath: indexPath)
        cell.configure(mileage: mileage)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = dataSource[indexPath]
        switch item {
        case .button:
            return CSButtonCell.cellSize
        case .refueling:
            return RefuelingInfoCell.cellSize
        case .text:
            return CSTextCell.cellSize()
        case .chart:
            return CSChartCell.cellSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
}

extension MainScreenViewController {
    func makeUI() {
        view.backgroundColor = .white
        
        // NAVBAR
        navBar = UINavigationBar()
        let navItem = UINavigationItem(title: "История")
        let addButton: UIBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addMileage))
        navItem.rightBarButtonItem = addButton
        navBar.setItems([navItem], animated: true)
        navBar.isTranslucent = false
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        
        label = UILabel()
        label.textAlignment = .center
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
        }
        
        button = UIButton()
        button.backgroundColor = .darkGray
        button.setTitle("Добавить показания одометра", for: .normal)
        button.layer.cornerRadius = 5
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(30)
        }
        
        // COLLECTION VIEW
        collectionView = makeCollectionView()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(button.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
    }
    
    private func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        
        let collectionView = CSCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }
    
    @objc func addMileage() {
        let vc = AddMileageViewController()
        if let last = self.viewModel.mileage.value.last {
            vc.viewModel = AddMileageViewModel(lastMileage: last)
        } else {
            let new = UserMileage()
            new.date = Date()
            new.odometer = 0
            vc.viewModel = AddMileageViewModel(lastMileage: new)
        }
        
        self.present(vc, animated: true, completion: nil)
    }
}
