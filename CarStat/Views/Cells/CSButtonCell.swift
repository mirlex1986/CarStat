//
//  CSButtonCell.swift
//  CarStat
//
//  Created by Aleksey Mironov on 17.09.2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CSButtonCell: RxCollectionViewCell {
    var button: UIButton!
    
    // MARK: - Lifecycle
    override func initialSetup() {
        super.initialSetup()
        
        makeUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func configure(text: String) {
        button.setTitle(text, for: .normal)
    }
}

extension CSButtonCell {
    private func makeUI() {
        backgroundColor = .clear
        
        button = UIButton()
        button.backgroundColor = .darkGray
        button.titleLabel?.textColor = .green
        button.layer.cornerRadius = 5
        contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(30)
            $0.height.equalTo(40)
        }
    }
}

extension CSButtonCell {
    static var cellSize: CGSize { CGSize(width: UIScreen.main.bounds.width, height: 60) }
}
