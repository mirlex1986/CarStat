import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CSTextCell: RxCollectionViewCell {
    // MARK: - UI
    private var title: UILabel!
    
    // MARK: - Lifecycle
    override func initialSetup() {
        super.initialSetup()
        
        makeUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        title.font = UIFont.systemFont(ofSize: 17)
        title.textColor = .darkText
    }
    
    func configure(text: String,
                   font: UIFont = UIFont.systemFont(ofSize: 17),
                   textColor: UIColor = .darkText,
                   textAlignment: NSTextAlignment = .left) {
        
        title.text = text
        title.font = font
        title.textColor = textColor
        title.textAlignment = textAlignment
    }
}

extension CSTextCell {
    private func makeUI() {
        backgroundColor = .clear
        
        // TITLE
        title = UILabel()
        title.numberOfLines = 0
        contentView.addSubview(title)
        title.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

extension CSTextCell {
    static func cellSize(text: String) -> CGSize {
        let width: CGFloat = Device.deviceWidth - 32
        let height = UILabel.calculateHeight(for: text, font: UIFont.systemFont(ofSize: 17), width: width)
        return CGSize(width: width, height: height)
    }
}
