import UIKit

class CSCollectionView: UICollectionView {}

extension CSCollectionView {
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        register(cellType: RefuelingInfoCell.self)
        register(cellType: RefuelingCell.self)
        register(cellType: MileageCell.self)
        
        register(cellType: CSButtonCell.self)
        register(cellType: CSTextCell.self)
        register(cellType: CSInputCell.self)
        register(cellType: CSDateInputCell.self)
        register(cellType: CSChartCell.self)
        register(cellType: CSEmptyCell.self)
    }
}

