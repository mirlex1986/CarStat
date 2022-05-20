//
//  ServicesViewController.swift
//  CarStat
//
//  Created by Aleksey Mironov on 17.05.2022.
//


import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class ServicesViewController: CSViewController {
    // MARK: - UI
    private var navBar: CSNavigationBar!
    private var collectionView: UICollectionView!
    private var label: UILabel!
    private var separator: UIView!
    private var button: UIButton!
    
    // MARK: - Properties
    typealias Item = ServicesViewModel.ItemModel
    typealias Section = ServicesViewModel.SectionModel
    
    var viewModel = ServicesViewModel()
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
        
        collectionView.rx.contentOffset
            .subscribe(onNext: { [weak self] offset in
                guard let self = self else { return }
                
                self.navBar.separatorIsHiddenTrigger.accept(offset.y <= 0)
            })
            .disposed(by: viewModel.disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }

                let item: Item = self.dataSource[indexPath]
                switch item {
 
                default:
                    break
                }
            })
            .disposed(by: viewModel.disposeBag)
        
        button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                
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
        
        return cell
    }
    
    private func textCell(indexPath: IndexPath, text: String, alignment: NSTextAlignment) -> CSCollectionViewCell {
        let cell: CSTextCell = collectionView.cell(indexPath: indexPath)
        cell.configure(text: text, textAlignment: alignment)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ServicesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = dataSource[indexPath]
        switch item {
        case .button:
            return CSButtonCell.cellSize
        case .text(let text, _):
            return CSTextCell.cellSize(text: text)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
}

extension ServicesViewController {
    override func makeUI() {
        view.backgroundColor = .white
        
        // NAVBAR
        navBar = CSNavigationBar()
        navBar.configureTitle(text: "Обслуживание")
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
        }
        
        label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
        }
        
        button = UIButton()
        button.backgroundColor = .lightBlue
        button.setTitle("Добавить", for: .normal)
        button.layer.cornerRadius = 5
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(40)
        }
        
        // SEPARATOR
        separator = UIView()
        separator.backgroundColor = .lightGray
        view.addSubview(separator)
        separator.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.bottom.equalTo(button.snp.top).offset(-10)
        }
        
        // COLLECTION VIEW
        collectionView = makeCollectionView()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.bottom.equalTo(separator)//.offset(-16)
            $0.left.right.equalToSuperview()
        }
    }
    
    private func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = CSCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        
        return collectionView
    }
}
