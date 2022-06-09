import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class CSNavigationBar: UIView {
    // MARK: - UI
    private var contentView: UIView!
    private var contentStackView: UIStackView!
    private var mainView: UIView!
    
    private var mainStackView: UIStackView!
    private var textStackView: UIStackView!
    private var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    private var leftContainer: UIView!
    private var rightContainer: UIView!
    private var separator: UIView!
    private var rightButtonImage: UIImageView!
    
    var leftButton: UIButton!
    var rightButton: UIButton!
    
    enum NavBarOptions: Equatable {
        case backButton
        case rightButton
        case subtitle(text: String)
    }
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var separatorIsHiddenTrigger = PublishRelay<Bool>()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        makeUI()
    }
    
    private func commonInit() {
        contentView = UIView()
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // MARK: - Functions
    func configure(title: String?, _ options: [NavBarOptions] = []) {
        titleLabel.text = title
        
        options.forEach {
            switch $0 {
            case .backButton:
                leftButton.isHidden = false
            case .subtitle(let text):
                subtitleLabel.text = text
            case .rightButton:
                rightButton.isHidden = false
                rightButtonImage.isHidden = false
            }
        }
        
        layoutIfNeeded()
        subscribe()
    }
    
    func configureBackgroundColor(_ color: UIColor) {
        contentView.backgroundColor = color
    }
    
    func configureTitle(text: String?) {
        titleLabel.text = text
        layoutIfNeeded()
        subscribe()
    }
    
    func configureTitleBar(isHidden: Bool) {
        mainView.isHidden = isHidden
    }
    
    func configureSubtitle(text: String?) {
        subtitleLabel.text = text
        layoutIfNeeded()
    }
    
    func configureBackButton(isHidden: Bool) {
        leftButton.isHidden = isHidden
    }
    
    func configureRightButton(isHidden: Bool) {
        rightButton.isHidden = isHidden
        rightButtonImage.isHidden = isHidden
    }
    
    func configureRightButton(image: UIImage,
                              backgroundColor: UIColor = .clear,
                              size: CGFloat = 26) {
        rightButtonImage.image = image
        rightButtonImage.backgroundColor = backgroundColor
        rightButtonImage.layer.cornerRadius = size / 2
        rightButtonImage.clipsToBounds = true
        rightButtonImage.snp.remakeConstraints {
            $0.right.equalToSuperview().offset(-14)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(size)
        }
    }
    
    private func subscribe() {
        separatorIsHiddenTrigger
            .subscribe(onNext: { [unowned self] trigger in
            
                self.separator.isHidden = trigger
            })
            .disposed(by: disposeBag)
    }
}

extension CSNavigationBar {
    private func makeUI() {
        backgroundColor = .clear
        clipsToBounds = true
        contentView.backgroundColor = .white
                
        // NAVBAR
        contentStackView = UIStackView()
        contentStackView.axis = .vertical
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
        
        // TOP NAVBAR SEGMENT
        mainView = UIView()
        mainView.backgroundColor = .clear
        contentStackView.addArrangedSubview(mainView)
        mainView.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        // LEFT BARBUTTON
        leftContainer = UIView()
        leftContainer.backgroundColor = .clear
        mainView.addSubview(leftContainer)
        leftContainer.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.equalTo(42)
        }
        
        // LEFT BUTTON
        leftButton = UIButton()
        leftButton.setTitle(nil, for: .normal)
        leftButton.setImage(Images.backButton, for: .normal)
        leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        leftButton.isHidden = true
        leftContainer.addSubview(leftButton)
        leftButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // RIGHT BARBUTTON
        rightContainer = UIView()
        rightContainer.backgroundColor = .clear
        mainView.addSubview(rightContainer)
        rightContainer.snp.makeConstraints {
            $0.right.bottom.top.equalToSuperview()
            $0.width.equalTo(42)
        }
        
        rightButtonImage = UIImageView()
        rightButtonImage.image = Images.close
        rightContainer.addSubview(rightButtonImage)
        rightButtonImage.isHidden = true
        rightButtonImage.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-14)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(26)
        }
        
        // RIGHT BUTTON
        rightButton = UIButton()
        rightButton.setTitle(nil, for: .normal)
        rightButton.isHidden = true
        rightContainer.addSubview(rightButton)
        rightButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // MIDLE NAVBAR ITEM
        mainStackView = UIStackView()
        mainStackView.spacing = 6
        mainView.addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.left.equalTo(leftContainer.snp.right).offset(12)
            $0.right.equalTo(rightButton.snp.left).offset(12)
        }
        
        // NAVBAR TITLE, SUBTITLE
        textStackView = UIStackView()
        textStackView.axis = .vertical
        textStackView.spacing = -2
        mainStackView.addArrangedSubview(textStackView)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        textStackView.addArrangedSubview(titleLabel)
        
        subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = .darkGray
        textStackView.addArrangedSubview(subtitleLabel)
        
        // SEPARATOR
        separator = UIView()
        separator.backgroundColor = .lightGray
        separator.isHidden = true
        contentStackView.addArrangedSubview(separator)
        separator.snp.makeConstraints {
            $0.height.equalTo(0.5)
        }
    }
}

