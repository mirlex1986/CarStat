import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class CSPopUpViewController: CSViewController {
    // MARK: - UI
    private var backgroundView: UIView!
    var contentView: UIView!
    private var stackView: UIStackView!
    var titleLabel: UILabel!
    private var subtitleLabel: UILabel!
    var closeButton: UIButton!
    var separator: UIView!

    private var tapGesture: UITapGestureRecognizer!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presentWithAnimation()
    }
    
    // MARK: - Functions
    private func subscribe() {
        tapGesture.rx.event
            .bind { [unowned self] _ in
                
                self.dismissWithAnimaion()
            }
            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                
                self.dismissWithAnimaion()
            })
            .disposed(by: disposeBag)
    }
    
    func configureSubtittle(_ text: String) {
        subtitleLabel.text = text
        
        stackView.snp.remakeConstraints {
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
    }
    
    func configureSeparator(isHidden: Bool) {
        separator.isHidden = isHidden
    }
    
    func configureCloseButton(isHidden: Bool) {
        closeButton.isHidden = isHidden
    }
}

extension CSPopUpViewController {
    override func makeUI() {
        super.makeUI()
        view.backgroundColor = .clear
        
        // BACKGROUND VIEW
        backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        containerView.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // TAP GESTURE
        tapGesture = UITapGestureRecognizer()
        backgroundView.addGestureRecognizer(tapGesture)
        
        // CONTENT VIEW
        contentView = UIView()
        contentView.backgroundColor = .white
        containerView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
        }
        
        // TITLE CONTAINER
        let titleContainer = UIView()
        contentView.addSubview(titleContainer)
        titleContainer.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(46)
        }

        // STACKVIEW
        stackView = UIStackView()
        stackView.axis = .vertical
        titleContainer.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }

        // TITLE
        titleLabel = UILabel()
        titleLabel.setFontSize(size: 17)
        titleLabel.setTextSpacingBy(value: -0.41)
        titleLabel.adjustsFontSizeToFitWidth = false
        stackView.addArrangedSubview(titleLabel)
        
        // SUBTITLE
        subtitleLabel = UILabel()
        subtitleLabel.setFontSize(size: 12)
        subtitleLabel.textColor = .lightText
        stackView.addArrangedSubview(subtitleLabel)
        
        // CLOSE BUTTON
        closeButton = UIButton()
        closeButton.setImage(Images.close, for: .normal)
        titleContainer.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.width.equalTo(46)
        }
        
        titleLabel.snp.makeConstraints {
            $0.right.equalTo(closeButton.snp.left)
        }
        
        // SEPARATOR
        separator = UIView()
        separator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        separator.isHidden = true
        contentView.addSubview(separator)
        separator.snp.makeConstraints {
            $0.top.equalTo(titleContainer.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

