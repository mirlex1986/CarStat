//
//  CSTableViewCell.swift
//  CarStat
//
//  Created by Aleksey Mironov on 27.04.2022.
//

import RxSwift

class CSTableViewCell: UITableViewCell {
//    override init(frame: CGRect) {
//        super.init(frame: .zero)
//        
//        initialSetup()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialSetup() {}
}

class RxTableViewCell: CSTableViewCell {
    var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }
}
