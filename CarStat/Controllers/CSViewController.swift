import UIKit
import RxSwift
import RxCocoa

protocol PickerController {
    var result: Observable<PickerResult?> { get }
}

class CSViewController: UIViewController {
    // MARK: - UI
    private var viewLoader: UIImageView!
//    private lazy var viewLoader: UIImageView = {
//        let viewLoader = UIImageView()
//        viewLoader.image = Images.loader
//        viewLoader.isHidden = true
//        view.addSubview(viewLoader)
//        viewLoader.snp.makeConstraints {
//            $0.center.equalToSuperview()
//            $0.size.equalTo(50)
//        }
//        return viewLoader
//    }()
    var containerView: UIView!
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var isPresentedModally: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
    }
}

extension CSViewController {
    @objc func makeUI() {
        
        // CONTAINER VIEW
        containerView = UIView()
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.size.equalToSuperview()
            $0.bottom.equalToSuperview().offset(Device.deviceHeight)
        }

        // MAIN LOADER VIEW
        viewLoader = UIImageView()
        viewLoader.image = Images.loader
        viewLoader.isHidden = true
        view.addSubview(viewLoader)
        viewLoader.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(50)
        }
    }
}

// MARK: - Public cells
extension CSViewController {
    public func emptyCell(_ collectionView: CSCollectionView, indexPath: IndexPath, color: UIColor = .clear) -> CSCollectionViewCell {
        let cell: CSEmptyCell = collectionView.cell(indexPath: indexPath)
        cell.configure(color: color)

        return cell
    }
    
    public func textCell(_ collectionView: CSCollectionView,
                         indexPath: IndexPath,
                         text: String,
                         font: UIFont = UIFont.systemFont(ofSize: 17),
                         color: UIColor = .darkText,
                         alignment: NSTextAlignment = .left) -> CSCollectionViewCell {
        let cell: CSTextCell = collectionView.cell(indexPath: indexPath)
        cell.configure(text: text, font: font, textColor: color, textAlignment: alignment)
        
        return cell
    }
}

extension CSViewController {
    private func configureBlurView(isHidden: Bool, completion: (() -> Void)? = nil) {
        var alpha: CGFloat = isHidden ? 0.3 : 0
        
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            self.view.backgroundColor = UIColor.black.withAlphaComponent(alpha)
            
            if isHidden {
                alpha -= 0.02
                if alpha <= 0 {
                    timer.invalidate()
                    completion?()
                }
            } else {
                alpha += 0.02
                if alpha > 0.3 {
                    timer.invalidate()
                    completion?()
                }
            }
        }
    }
    
    func presentWithAnimation() {
        configureBlurView(isHidden: false)
        
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: -Device.deviceHeight)
        }
    }
    
    func dismissWithAnimaion(completion: (() -> Void)? = nil) {
        self.view.endEditing(true)
 
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: Device.deviceHeight)
        }
        
        self.configureBlurView(isHidden: true) { self.dismiss(animated: false, completion: completion) }
    }
    
    func configureMainLoader(isHidden: Bool) {
        view.bringSubviewToFront(viewLoader)
        viewLoader.isHidden = isHidden
        viewLoader.rotate()
    }
}
