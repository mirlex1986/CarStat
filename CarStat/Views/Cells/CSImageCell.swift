import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CSImageCell: RxCollectionViewCell {
    
    // MARK: - UI
    private var iconView: UIImageView!
    private var titleLabel: UILabel!
    private var borderView: UIView!
    
    // MARK: - Lifecycle
    override func initialSetup() {
        super.initialSetup()
        makeUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func configure(image: UIImage) {
        iconView.image = image
    }
}

extension CSImageCell {
    private func makeUI() {
        backgroundColor = .clear
        
        // ICON VIEW
        iconView = UIImageView()
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.top.bottom.centerX.equalToSuperview()
        }
        
        // BORDER
        borderView = UIView()
        borderView.isHidden = true
        borderView.layer.cornerRadius = 2
        borderView.layer.borderWidth = 1
        borderView.clipsToBounds = true
        contentView.addSubview(borderView)
        borderView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(70)
        }
       
        // TEXT
        titleLabel = UILabel()
        titleLabel.isHidden = true
        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(5)
            $0.centerY.equalTo(borderView)
        }
    }
}

extension CSImageCell {
    static func cellSize(height: CGFloat) -> CGSize {
        return CGSize(width: Device.deviceWidth - 32, height: height)
    }
    
    static func cellSize(width: CGFloat, height: CGFloat) -> CGSize {
        return CGSize(width: Device.deviceWidth, height: height)
    }
    
    static var cellSize: CGSize {
        return CGSize(width: Device.deviceWidth, height: Device.deviceHeight * 3 / 4)
    }
}
