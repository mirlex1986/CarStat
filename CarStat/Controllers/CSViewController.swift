import UIKit
import RxSwift
import RxCocoa

protocol PickerController {
    var result: Observable<PickerResult?> { get }
}

class CSViewController: UIViewController {
    // MARK: - UI
    private var viewLoader: UIImageView!
    var containerView: UIView!
    
    var viewTapGesture: UITapGestureRecognizer!
    
    // MARK: - Properties
    var disposeBag = DisposeBag()
    var isPresentedModally: Bool = false
    
    private var tabBarHeight: CGFloat {
        if let tabBar = self.tabBarController?.tabBar, !tabBar.isHidden {
            return tabBar.frame.height
        } else {
            return 0
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
    }
}

extension CSViewController {
    @objc func makeUI() {
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        // CONTAINER VIEW
        containerView = UIView()
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.size.equalToSuperview()
            $0.bottom.equalToSuperview().offset(Device.deviceHeight)
        }
        
        // TAP GESTURE RECOGNISER
        viewTapGesture = UITapGestureRecognizer()
        viewTapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(viewTapGesture)
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
}
